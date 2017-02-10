class EnsureTasksSortPositionIsNotNullable < ActiveRecord::Migration[5.0]
  def change
    change_column :tasks, :sort_position, :decimal, :precision => 10, :scale => 5, :null => false
  end
end
