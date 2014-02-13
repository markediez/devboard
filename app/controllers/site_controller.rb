class SiteController < ApplicationController
  skip_before_filter :authenticate, :only => [:access_denied]
  
  # GET /overview
  def overview
    @developers = Developer.all
    @projects = Project.all
    authorize! :manage, @developers
    authorize! :manage, @projects
  end
  
  # GET /access_denied
  # Unauthenticated requests are redirected here
  def access_denied
    
  end
end
