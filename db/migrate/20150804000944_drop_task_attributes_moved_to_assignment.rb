class DropTaskAttributesMovedToAssignment < ActiveRecord::Migration
  def change
    remove_column :tasks, :completed
    remove_column :tasks, :assignee_id
  end
end
