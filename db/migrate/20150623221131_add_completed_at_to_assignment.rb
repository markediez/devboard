class AddCompletedAtToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :completed_at, :datetime
  end
end
