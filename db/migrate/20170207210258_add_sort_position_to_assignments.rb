class AddSortPositionToAssignments < ActiveRecord::Migration[5.0]
  def change
    add_column :assignments, :sort_position, :int, :default => 0, :null => false
  end
end
