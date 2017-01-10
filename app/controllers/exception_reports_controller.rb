class ExceptionReportsController < ApplicationController
  before_action :set_exception_report, only: [:show, :edit, :update, :destroy]

  # GET /exception_reports
  def index
    @exception_reports = ExceptionReport.all
    @projects = Project.all

    # @test = []
    # @exception_reports.each do |er|
    #   @test << er.build_exception_from_email
    # end
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
      params.require(:exception_report).permit(:project_id, :subject, :body, :gh_issue_id, :duplicate, exception_from_email_attributes: [:id, :project_id])
    end
end
