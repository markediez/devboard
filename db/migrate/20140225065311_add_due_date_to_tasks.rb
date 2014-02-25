class AddDueDateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :due, :datetime, :default => nil
  end
end
