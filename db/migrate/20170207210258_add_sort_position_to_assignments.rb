class AddSortPositionToAssignments < ActiveRecord::Migration[5.0]
  def change
    # sort_position should not be null. <=> cannot compare null values
    add_column :assignments, :sort_position, :int, :default => 0, :null => false

    Assignment.transaction do
      Assignment.all.each do |a|
        a.sort_position = a.task.sort_position
        a.save!
      end
    end
  end
end
