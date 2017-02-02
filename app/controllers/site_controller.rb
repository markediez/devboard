class SiteController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:credentials]
  skip_before_action :authenticate, only: [:access_denied, :logout]

  # GET /overview
  def overview
    @tasks = Task.where.not(:id => Assignment.select(:task_id).uniq).where(:completed_at => nil).order(:sort_position => "ASC")
    @time_to_view = params[:time_in_seconds].present? ? Time.at(params[:time_in_seconds].to_i) : Time.now
    # OLD
    # Duration is in days for site#overview (weeks for developer#show)
    if params[:duration] and [7, 14, 21, 28].include?(params[:duration].to_i)
      @duration = params[:duration].to_i
    else
      # Default
      @duration = 7
    end

    @commits = Commit.where('committed_at >= :date', date: Time.now - @duration.days).order(committed_at: :desc)

    # Set up data for the last 12 weeks (3 months) of commits (for Chart.js)
    @recent_commits_graph = {}
    @recent_lines_graph = {}

    # Fill the graph data in with zeroes in case there are no commits that
    # week. We do not want to handle gaps in data in Chart.js
    for i in 0..@duration
      @recent_commits_graph[(Time.now - i.days).strftime("%Y%j").to_i] = 0
      @recent_lines_graph[(Time.now - i.days).strftime("%Y%j").to_i] = 0
    end

    @recent_commits_by_project = {}
    @recent_lines_by_project = {}

    # Calculate the developer's average commits per week
    @commits.each do |commit|
      idx = commit.committed_at.strftime("%Y%j").to_i
      @recent_commits_graph[idx] += 1
      @recent_lines_graph[idx] += commit.total

      if commit.project
        @recent_commits_by_project[commit.project.name] = @recent_commits_by_project[commit.project.name].to_i + 1
        @recent_lines_by_project[commit.project.name] = @recent_lines_by_project[commit.project.name].to_i + commit.total
      end
    end

    @recent_commits_graph = @recent_commits_graph.sort_by { |timestamp, commits| timestamp }
    @recent_lines_graph = @recent_lines_graph.sort_by { |timestamp, lines| timestamp }
    @recent_commits_by_project = @recent_commits_by_project.sort_by { |name, commits| -1 * commits }
    @recent_lines_by_project = @recent_lines_by_project.sort_by { |name, lines| -1 * lines }
    @total_commit_count = @commits.count

    # Original view code
    @developers = Developer.order(created_at: :desc)
    @activities = ActivityLog.order(when: :desc).limit(6)
    @past_due_tasks = Task.where(completed_at: nil).where('due < ?', DateTime.now).order(due: :asc)
    @due_soon_tasks = Task.where(completed_at: nil).where('due < ?', DateTime.now + 14.days).where('due > ?', DateTime.now).order(due: :asc)
    @no_due_date_tasks = Task.where(completed_at: nil).where(due: nil)

    # Get all open assignments
    @open_assignments = {}
    unsorted_assignments = Assignment.all.select{ |a| a.task.completed_at.nil? }
    unsorted_assignments.each do |assignment|
      if assignment.developer_account and assignment.developer_account.developer and assignment.developer_account.developer.active
        @open_assignments[assignment.developer_account.developer.id] = [] if @open_assignments[assignment.developer_account.developer.id].nil?
        @open_assignments[assignment.developer_account.developer.id] << assignment
      end
    end

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
