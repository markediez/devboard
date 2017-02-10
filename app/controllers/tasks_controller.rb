class TasksController < ApplicationController
  load_and_authorize_resource
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @past_due_tasks = Task.where(completed_at: nil).where('due < ?', DateTime.now).order(due: :asc)
    @due_soon_tasks = Task.where(completed_at: nil).where('due < ?', DateTime.now + 14.days).where('due > ?', DateTime.now).order(due: :asc)
    @no_due_date_tasks = Task.where(completed_at: nil).where(due: nil)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @task.assignments.build

    if params[:project_id] and (Project.find_by_id(params[:project_id]) != nil)
      @task.project_id = params[:project_id]
    else
      #flash[:alert] = "Invalid Project ID."
      #redirect_to projects_url
    end
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    # Add task as an issue if a repository is chosen to sync with
    if @task.valid? and params[:repository].present? and params[:repository][:repository_id] != ""
      require 'github'
      @task.repository_id = params[:repository][:repository_id]
      gh_issue_no = GitHubService.create_issue(@task, Repository.find(@task.repository_id).url)
      @task.gh_issue_number = gh_issue_no
    end

    respond_to do |format|
      if @task.save
        notice_txt = 'Task was successfully created.'
        notice_txt += " GitHub issue ##{@task.gh_issue_number}." if @task.gh_issue_number
        notice_txt += " GitHub issue failed to sync. Check credentials." if @task.valid? and params[:create_github_issue] == '1' and @task.gh_issue_number.nil?

        ActivityLog.create!({developer_id: current_user.developer_id, project_id: @task.project_id, task_id: @task.id, activity_type: :created })

        format.html { redirect_to @task, notice: notice_txt }
        format.json { render action: 'show', status: :created, location: @task }
      else
        logger.debug @task.errors.full_messages

        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    completed_val_before = @task.completed_at

    respond_to do |format|
      if @task.update(task_params)

        # Was this task completed or merely updated?
        # AR Dirty will clear @task.changes in the above update but we need to do this
        # after the update in order to know that the update was successful.
        if(completed_val_before != @task.completed_at)
          ActivityLog.create!({developer_id: current_user.developer_id, project_id: @task.project_id, task_id: @task.id, activity_type: :completed })

          unless @task.completed_at.blank?
            if @task.gh_issue_number
              Rails.logger.debug "Closing a GitHub issue ..."

              require 'github'

              GitHubService.close_issue(@task)
            else
              Rails.logger.debug "Not closing a GitHub issue."
            end
          else
            if @task.gh_issue_number
              Rails.logger.debug "Opening a GitHub issue ..."

              require 'github'

              GitHubService.reopen_issue(@task)
            else
              Rails.logger.debug "Not opening a GitHub issue."
            end
          end
        else
          ActivityLog.create!({developer_id: current_user.developer_id, project_id: @task.project_id, task_id: @task.id, activity_type: :edited })
        end

        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        logger.debug @task.errors.full_messages

        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      # :developer_account_id param and :task_id are for unassigning tasks in the overview page
      params.require(:task).permit(:title, :sort_position, :details, :creator_id, :project_id, :completed_at, :difficulty, :duration, :due, :priority, :points, :assignment, :repository, :developer_account_id, :task_id, assignments_attributes: [:id, :developer_account_id, :_destroy, :assigned_at], :task_ids => [])
    end
end
