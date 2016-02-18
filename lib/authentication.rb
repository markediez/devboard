module Authentication
  @current_user = nil

  # Returns the current_user, which may be 'false' if impersonation is active
  def current_user
    if impersonating?
      return @current_user
    else
      auth_via = defined?(session) ? session[:auth_via] : nil

      case auth_via
      # when :whitelisted_ip
      #   return ApiWhitelistedIpUser.find_by_address(session[:user_id])
      when :api_key
        return ApiKeyUser.find_by_name(session[:user_id])
      when :cas
        return @current_user
      end
    end

    return nil
  end

  # Returns the 'actual' user - usually this matches current_user but when
  # impersonating, it will return the human doing the impersonating, not the
  # account they are pretending to be. Useful for determining if actions like
  # 'un-impersonate' should be made available.
  def actual_user
    User.find_by_id(session[:user_id])
  end

  # Ensure session[:auth_via] exists.
  # This is populated by a whitelisted IP request, a CAS redirect or a HTTP Auth request
  def authenticate
    # Check for CAS single sign out requests
    if params[:logoutRequest]
      CASClient::Frameworks::Rails::Filter.before(self)
      return
    end

    # Disallow sessions older than 10 minutes
    # Note: If they're still authenticated via CAS, their session will restart after a redirect.
    reset_session if session[:last_seen] and ((session[:last_seen] + 10.minutes) < Time.now)

    if session[:auth_via]
      case session[:auth_via]
      when :api_key
        Authentication.actual_user = ApiKeyUser.find_by_name(session[:user_id])
        logger.info "Authentication passed with existing session (API key): #{session[:user_id]}"
      
      when :cas
        if session[:cas_user]
          if impersonating?
            @current_user = User.find_by_id(session[:impersonation_id])
          else
            @current_user = User.find_by_id(session[:user_id])
          end

          logger.info "User authentication passed due to existing session: #{session[:auth_via]}, #{session[:user_id]}, #{@current_user}"
          session[:last_seen] = Time.now
        else
          logger.info "Previous CAS session data exists but CAS is not logged in. Expiring this session ..."
          session.delete(:user_id)
          session.delete(:auth_via)
        end
      end

      return
    end

    # Check if HTTP Auth is being attempted.
    authenticate_with_http_basic { |name, secret|
      @api_user = ApiKeyUser.find_by_name_and_secret(name, secret)

      if @api_user
        logger.info "API authenticated via application key"
        session[:user_id] = name
        session[:auth_via] = :api_key
        return
      end

      logger.info "API authentication failed. Application key is wrong."
      # Note that they will only get 'access denied' if they supplied a name and
      # failed. If they supplied nothing for HTTP Auth, this block will get passed
      # over.
      render :text => "Invalid API key (#{name}).", :status => 401

      return
    }

    # No existing session. Redirect to site#credentials if necessary.
    unless (params[:controller] == 'site') and (params[:action] == 'credentials')
      # It's important that CAS sees this request as coming from /credentials so that CAS sends
      # the single sign _out_ request to it as well. The single sign _out_ request requires we
      # turn off CSRF protection, so /credentials is the one page where we do so.
      session[:url_before_redirect] = request.original_url

      redirect_to :controller => 'site', :action => 'credentials'
    else
      # If environment variable 'CAS' is set and we're in development mode,
      # allow the CAS redirect to be bypassed and ENV['CAS'] to be the assumed user.
      if Rails.env.development? and ENV['CAS']
        session[:cas_user] = ENV['CAS']
        params[:ticket] = 'cas-123456'
      else
        # It's important we do this before checking session[:cas_user] as it
        # sets that variable. Note that the way before_filters work, this call
        # will render or redirect but this function will still finish before
        # the redirect is actually made.
        CASClient::Frameworks::Rails::Filter.before(self)
      end

      if session[:cas_user]
        # CAS session exists. Valid user account?
        @user = User.find_by_loginid(session[:cas_user])
        @user = nil if @user and @user.active == false # Don't allow disabled users to log in

        if @user
          # Valid user found through CAS.
          session[:user_id] = @user.id
          session[:auth_via] = :cas
          session[:last_seen] = Time.now

          @current_user = @user

          @user.logged_in_at = DateTime.now()
          @user.save

          logger.info "CAS user is in our database, passes authentication."

          if params[:ticket] and params[:ticket].include? "cas"
            # This is a session-initiating CAS login, so remove the damn GET parameter from the URL for UX
            redirect_url = session[:url_before_redirect]

            if redirect_url.present?
              session.delete(:url_before_redirect)
              redirect_to redirect_url
            else
              redirect_to :controller => 'site', :action => 'overview'
            end

            return
          end

          # TODO: Does the code below ever get reached?

          # New sessions already logged into CAS will fall through to here but
          # still be on site#credentials, which is not a valid page. Redirect.
          if (params[:controller] == 'site') and (params[:action] == 'credentials')
            redirect_url = session[:url_before_redirect]

            if redirect_url.present?
              session.delete(:url_before_redirect)
              redirect_to redirect_url
            else
              redirect_to :controller => 'site', :action => 'overview'
            end
          end

          return
        else
          # Proper CAS request but user not in our database.
          session[:user_id] = nil
          session[:auth_via] = nil
          session[:last_seen] = nil

          logger.warn "CAS user is denied. Not in our local database or is disabled."
          flash[:error] = 'You have authenticated but are not allowed access.'

          redirect_to :controller => 'site', :action => 'access_denied'
        end
      end
    end
  end

  # Returns true if we're currently impersonating another user
  def impersonating?
    (defined?(session) && session[:impersonation_id]) ? true : false
  end
end
