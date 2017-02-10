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

  def create
    @assignment = Assignment.new(assignment_params)

    respond_to do |format|
      if @assignment.save
        format.json { render :show, status: :created, location: @assignment }
      else
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /assignments/update
  def update
    respond_to do |format|
      ActiveRecord::Base.transaction do
        # Update the sort_position of all assignments for this developer by 1 if they fall after the desired params[:sort_position]
        da = DeveloperAccount.find_by_id(params[:assignment][:developer_account_id])
        Assignment.where(:developer_account_id => da.linked_accounts).where("sort_position < ?", assignment_params[:sort_position]).update_all("sort_position = sort_position - 1")
        Assignment.where(:developer_account_id => da.linked_accounts).where("sort_position >= ?", assignment_params[:sort_position]).update_all("sort_position = sort_position + 1")

        if @assignment.update(assignment_params)
          format.json { render :show, status: :ok, location: @assignment }
        else
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
