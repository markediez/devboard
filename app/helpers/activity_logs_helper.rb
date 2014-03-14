module ActivityLogsHelper
  # Parses an Activity model and generates the English description
  def activity_to_s(activity)
    # Task-based activity log
    if activity.task_id
      return link_to(activity.developer.name, activity.developer) + " <b>".html_safe + activity.activity_type.to_s + " the task</b> ".html_safe + link_to(activity.task.title, activity.task) + " in " + link_to(activity.project.name, activity.project)
    end
    if activity.meeting_note_id
      return link_to(activity.developer.name, activity.developer) + " <b>".html_safe + activity.activity_type.to_s + " the meeting note</b> ".html_safe + link_to(activity.meeting_note.title, activity.meeting_note) + " in " + link_to(activity.project.name, activity.project)
    end
    if activity.project_id and not activity.task_id and not activity.meeting_note_id and not activity.commit_gh_id
      return link_to(activity.developer.name, activity.developer) + " <b>".html_safe + activity.activity_type.to_s + " the project</b> ".html_safe + link_to(activity.project.name, activity.project)
    end
    if activity.developer_id and not activity.project_id and not activity.task_id and not activity.meeting_note_id
      return link_to(activity.developer.name, activity.developer) + " was <b>added</b> as a developer".html_safe
    end
    if activity.commit_gh_id
      return link_to(activity.developer.name, activity.developer) + " <b>".html_safe + activity.activity_type.to_s + "ted code to the project</b> ".html_safe + link_to(activity.project.name, activity.project)
    end
  end
end
