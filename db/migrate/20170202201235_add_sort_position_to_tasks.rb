class AddSortPositionToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :sort_position, :int, :default => 0
    remove_column :assignments, :sort_position
  end
end
