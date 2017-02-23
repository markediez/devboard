json.array!(ExceptionReport.all) do |er|
  json.extract! er, :id, :subject, :body, :gh_issue_id, :duplicated_id, :created_at, :updated_at, :task_id, :email_from, :project_id
  json.url exception_report_url(er, format: :json)
end
