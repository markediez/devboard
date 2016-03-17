json.array!(@milestones) do |milestone|
  json.extract! milestone, :id, :title, :description, :due_on, :completed_at, :gh_milestone_number
  json.url milestone_url(milestone, format: :json)
end
