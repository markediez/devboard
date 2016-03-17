class RemoveCompletedAtFromAssignment < ActiveRecord::Migration
  def change
    remove_column :assignments, :completed_at
  end
end
