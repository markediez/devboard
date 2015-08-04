class RestoreCompletedAtToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :completed_at, :datetime, :default => nil
  end
end
