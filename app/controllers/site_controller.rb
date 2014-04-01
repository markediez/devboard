class SiteController < ApplicationController
  skip_before_filter :authenticate, :only => [:access_denied, :logout]
  skip_before_action :verify_authenticity_token, only: :credentials

  # GET /overview
  def overview
    @developers = Developer.order(created_at: :desc)
    @activities = ActivityLog.order(when: :desc).limit(15)
    @past_due_tasks = Task.where(completed: nil).where('due < ?', DateTime.now).order(due: :asc)
    @due_soon_tasks = Task.where(completed: nil).where('due < ?', DateTime.now + 10.days).where('due > ?', DateTime.now).order(due: :asc)

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

  # GET /credentials
  # POST /credentials
  # Redirects to CAS are made from here so CAS single sign out will then
  # post back to this URL, giving us one safe URL to disable CSRF protection.
  def credentials
  end
end
