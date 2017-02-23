class AllowNullValuesForSortPositionInAssignments < ActiveRecord::Migration[5.0]
  def change
	change_column :assignments, :sort_position, :decimal, :precision => 10, :scale => 5, :null => true
  end
end
