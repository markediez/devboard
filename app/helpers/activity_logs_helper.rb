module ActivityLogsHelper
  # Parses an Activity model and generates the English description
  def activity_to_s(activity)
    # Task-based activity log
    if activity.task_id
      link_to(activity.developer.name, activity.developer) + " <b>".html_safe + activity.activity_type.to_s + " the task</b> ".html_safe + link_to(activity.task.description, activity.task) + " in " + link_to(activity.project.name, activity.project)
    end
  end
end
