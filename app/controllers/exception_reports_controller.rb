class ExceptionReportsController < ApplicationController
  before_action :set_exception_report, only: [:show, :edit, :update, :destroy]

  # GET /exception_reports
  def index
    @exception_reports = ExceptionReport.all
    @projects = Project.all
    @developers = Developer.all
  end

  # GET /exception_reports/1
  def show
  end

  # GET /exception_reports/new
  def new
    @exception_report = ExceptionReport.new
  end

  # GET /exception_reports/1/edit
  def edit
  end

  # POST /exception_reports
  def create
    @exception_report = ExceptionReport.new(exception_report_params)

    if @exception_report.save
      redirect_to @exception_report, notice: 'Exception report was successfully created.'
    else
      render :new
    end
  end

  # POST /exception_report/new_task
  def new_task
    # Create a task with the report's details
    @task = Task.new(:title => params[:new_task][:title], :details => params[:new_task][:details])
    @task.save!

    # Reference the task created for the report
    @exception_report = ExceptionReport.where(:id => params[:new_task][:id]).first
    @exception_report.task = @task
    @exception_report.save!

    # Flash notice
    redirect_to exception_reports_url, notice: 'Exception report was successfully updated.'
  end

  # PATCH/PUT /exception_reports/1
  def update
    if @exception_report.update(exception_report_params)
      redirect_to exception_reports_url, notice: 'Exception report was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /exception_reports/1
  def destroy
    @exception_report.destroy
    redirect_to exception_reports_url, notice: 'Exception report was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exception_report
      @exception_report = ExceptionReport.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def exception_report_params
      params.require(:exception_report).permit(:project_id, :subject, :body, :gh_issue_id, :duplicate, exception_from_email_attributes: [:id, :project_id], new_task: [:title, :details, :id])
    end
end
