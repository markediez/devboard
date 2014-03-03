class AddTaskIdToActivityLog < ActiveRecord::Migration
  def change
    add_column :activity_logs, :task_id, :integer, :default => nil
  end
end
