json.array!(@sprints) do |sprint|
  json.extract! sprint, :id, :milestone_id, :started_at, :finished_at, :points_attempted, :points_completed
  json.url sprint_url(sprint, format: :json)
end
