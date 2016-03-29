class AddMilestoneIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :milestone_id, :integer
  end
end
