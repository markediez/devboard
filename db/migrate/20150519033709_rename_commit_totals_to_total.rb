class RenameCommitTotalsToTotal < ActiveRecord::Migration
  def change
    rename_column :commits, :totals, :total
  end
end
