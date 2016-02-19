json.open_assignments @open_assignments.each do |assignment|
 json.developer @developers.find(assignment[0]).name 
  json.assignments assignment[1] do |tasks|
    json.project tasks.task.project.name
    json.project_id tasks.task.project.id
    json.task tasks.task.title
    json.task_id tasks.task.id
  end
end