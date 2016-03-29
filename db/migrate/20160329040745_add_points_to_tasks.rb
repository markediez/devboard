class AddPointsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :points, :float
  end
end
