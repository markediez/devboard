class SiteController < ApplicationController
  skip_before_filter :authenticate, :only => [:access_denied, :logout]
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
    if @current_user
      redirect_to :controller => 'site', :action => 'overview'
    end
  end
end
