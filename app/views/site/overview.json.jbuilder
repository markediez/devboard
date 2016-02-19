json.open_assignments @open_assignments.each do |assignment|
 json.developer @developers.where(id: assignment[0])[0].name 
  json.assignments assignment[1] do |a|
    json.project a.task.project.name
    json.project_id a.task.project.id
    json.task a.task.title
    json.task_id a.task.id
  end
end