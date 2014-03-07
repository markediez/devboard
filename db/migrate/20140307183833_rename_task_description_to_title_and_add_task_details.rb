class RenameTaskDescriptionToTitleAndAddTaskDetails < ActiveRecord::Migration
  def change
    rename_column :tasks, :description, :title
    add_column :tasks, :details, :text
  end
end
