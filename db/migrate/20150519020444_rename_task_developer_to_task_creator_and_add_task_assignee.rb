class RenameTaskDeveloperToTaskCreatorAndAddTaskAssignee < ActiveRecord::Migration
  def change
    rename_column :tasks, :developer_id, :creator_id
    add_column :tasks, :assignee_id, :integer
  end
end
