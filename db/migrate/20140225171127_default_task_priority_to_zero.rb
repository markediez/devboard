class DefaultTaskPriorityToZero < ActiveRecord::Migration
  def change
    change_column :tasks, :priority, :integer, :default => 0
  end
end
