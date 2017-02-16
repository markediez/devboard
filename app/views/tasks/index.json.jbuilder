json.array!(@tasks) do |task|
  json.extract! task, :id, :title, :details, :due, :project_id, :completed_at
  json.url task_url(task, format: :json)
end
