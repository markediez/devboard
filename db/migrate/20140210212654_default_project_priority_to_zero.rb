class DefaultProjectPriorityToZero < ActiveRecord::Migration
  def change
    change_column :projects, :priority, :integer, :default => 0
  end
end
