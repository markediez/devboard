class AddCommitStatsToCommits < ActiveRecord::Migration
  def change
    add_column :commits, :additions, :integer
    add_column :commits, :deletions, :integer
    add_column :commits, :totals, :integer
  end
end
