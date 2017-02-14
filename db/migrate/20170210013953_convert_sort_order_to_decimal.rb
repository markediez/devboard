class ConvertSortOrderToDecimal < ActiveRecord::Migration[5.0]
  def change
    change_column :tasks, :sort_position, :decimal, :precision => 10, :scale => 5
    change_column :assignments, :sort_position, :decimal, :precision => 10, :scale => 5
  end
end
