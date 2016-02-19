json.open_assignments @open_assignments.each do |open_assignment|
 json.developer @developers.find(open_assignment[0]).name 
  json.assignments open_assignment[1].each do |assignment|
    json.project assignment.task.project.name
    json.task_title assignment.task.title
    json.task_link url_for(assignment.task)
  end
end