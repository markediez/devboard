require 'test_helper'

class ExceptionReportsControllerTest < ActionController::TestCase
  setup do
    @exception_report = exception_reports(:one)
    CASClient::Frameworks::Rails::Filter.fake('casuser')
    session[:auth_via] = :cas
    session[:user_id] = 1
    session[:cas_user] = 'casuser'
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  #test "should create exception_report" do
  #  assert_difference('ExceptionReport.count') do
  #    post exception_reports_url, params: { exception_report: { body: @exception_report.body, duplicate: @exception_report.duplicate, gh_issue_id: @exception_report.gh_issue_id, project_id: @exception_report.project_id, subject: @exception_report.subject } }
  #  end

  #  assert_redirected_to exception_report_url(ExceptionReport.last)
  #end

  #test "should update exception_report" do
  #  patch exception_report_url(@exception_report), params: { exception_report: { body: @exception_report.body, duplicate: @exception_report.duplicate, gh_issue_id: @exception_report.gh_issue_id, project_id: @exception_report.project_id, subject: @exception_report.subject } }
  #  assert_redirected_to exception_report_url(@exception_report)
  #end

  #test "should destroy exception_report" do
  #  assert_difference('ExceptionReport.count', -1) do
  #    delete exception_report_url(@exception_report)
  #  end

  #  assert_redirected_to exception_reports_url
  #end
end
