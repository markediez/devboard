class DefaultTaskPriorityToOne < ActiveRecord::Migration
  def change
    change_column :tasks, :priority, :integer, :default => 1
  end
end
