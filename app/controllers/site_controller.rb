class SiteController < ApplicationController
  skip_before_filter :authenticate, :only => [:access_denied, :logout, :credentials]
  skip_before_action :verify_authenticity_token, only: [:credentials]
  
  # GET /overview
  def overview
    @developers = Developer.all
    @activities = ActivityLog.order(when: :desc).limit(30)
    authorize! :manage, @developers
    authorize! :manage, @activity
  end
  
  # GET /access_denied
  # Unauthenticated requests are redirected here
  def access_denied
  end
  
  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
  
  def credentials
    if params[:logoutRequest]
      logger.debug 'CAS logout.'
      
      render nothing: true
    else
      authenticate
    end
  end
end
