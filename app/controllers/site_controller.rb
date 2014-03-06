class SiteController < ApplicationController
  skip_before_filter :authenticate, :only => [:access_denied]
  
  # GET /overview
  def overview
    @developers = Developer.all
    @activities = ActivityLog.order('\'activity_logs.when\' DESC').limit(30)
    authorize! :manage, @developers
    authorize! :manage, @activity
  end
  
  # GET /access_denied
  # Unauthenticated requests are redirected here
  def access_denied
    
  end
end
