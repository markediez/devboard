class AssignmentsController < ApplicationController
  # GET /overview
  def index
    @tasks = Task.where.not(:id => Assignment.select(:task_id).uniq).where(:completed_at => nil).order(:sort_position => "ASC")
    @time_to_view = params[:time].present? ? DateTime.parse(params[:date]) : Time.now

    @developers = Developer.where(:active => true).order(created_at: :desc)

    authorize! :manage, @developers
    authorize! :manage, @activity
  end
end
