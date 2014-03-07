json.array!(@tasks) do |task|
  json.extract! task, :id, :title, :details, :developer_id, :project_id, :completed
  json.url task_url(task, format: :json)
end
