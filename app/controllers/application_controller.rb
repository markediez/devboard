class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # Require authentication on all requests
  include Authentication
  before_filter :authenticate
  
  # Workaround for Can Can / Rails 4.0 bug (https://github.com/ryanb/cancan/issues/835)
  before_filter do
    resource = controller_path.singularize.gsub('/', '_').to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    logger.debug 'CanCan threw AccessDenied. Redirecting to /access_denied ...'
    redirect_to access_denied_path, :alert => exception.message
  end
  
  protected

  def permission_denied
    if session[:auth_via] == :cas
      # Human-facing error
      flash[:error] = "Sorry, you are not allowed to access that page."
      redirect_to access_denied_path
    else
      # Machine-facing error
      render :text => "Permission denied.", :status => 403
    end
  end
end
