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
    respond_to do |format|
      ActiveRecord::Base.transaction do
        puts "here1"
        # Update the sort_position of all assignments for this developer by 1 if they fall after the desired params[:sort_position]
        account_ids = DeveloperAccount.find_by_id(assignment_params[:developer_account_id]).developer.accounts.ids
        Assignment.where(:developer_account_id => account_ids).where("sort_position >= ?", assignment_params[:sort_position]).update_all("sort_position = sort_position + 1")

        puts "here2"

        byebug

        if @assignment.update(assignment_params)
          puts "here3"
          format.json { render :show, status: :ok, location: @assignment }
        else
          puts "here3 uh oh"
          format.json { render json: @assignment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @assignment.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
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
