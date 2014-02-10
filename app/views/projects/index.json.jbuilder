json.array!(@projects) do |project|
  json.extract! project, :id, :name, :status, :began, :finished, :priority
  json.url project_url(project, format: :json)
end
