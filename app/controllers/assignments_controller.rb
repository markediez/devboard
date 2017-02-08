class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:update, :destroy]

  # GET /overview
  def index
    @tasks = Task.where.not(:id => Assignment.select(:task_id).uniq).where(:completed_at => nil).order(:sort_position => "ASC")
    @time_to_view = params[:time].present? ? DateTime.parse(params[:date]) : Time.now

    @developers = Developer.where(:active => true).order(created_at: :desc)

    authorize! :manage, @developers
    authorize! :manage, @activity
  end

  # POST /assignments/update
  def update
    # # Grab the developer and tasks
    # developer_account_id = params["developer_account_id"]
    # tasks = params["task_ids"]
    # positions = (0...tasks.size).to_a

    # # Use raw SQL to update because rails does not support cases
    # sql = "UPDATE assignments SET sort_position = CASE task_id "
    # where = "WHERE developer_account_id = #{developer_account_id} AND task_id IN ("
    # positions.each do |i|
    #   sql += "WHEN #{tasks[i]} THEN #{i} "
    #   where += "#{tasks[i]}"
    #   where += (i == positions.last) ? ")" : ", "
    # end
    # sql += "END "
    # sql += where

    # # Update each assigned task to new position
    # ActiveRecord::Base.transaction do
    #   ActiveRecord::Base.connection.execute(sql)
    # end
  end

  def destroy

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.require(:assignment).permit(:id, :developer_account_id, :task_id, :sort_position)
    end
end
