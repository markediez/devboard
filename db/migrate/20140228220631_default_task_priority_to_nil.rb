class DefaultTaskPriorityToNil < ActiveRecord::Migration
  def change
    change_column :tasks, :priority, :integer, :default => nil
  end
end
