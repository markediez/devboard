class AddAssignedAtDueAtDelayCountToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :due_at, :datetime
    add_column :assignments, :assigned_at, :datetime
    add_column :assignments, :delay_count, :integer, :default => 0
  end
end
