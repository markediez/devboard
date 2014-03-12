class AddCommitGhIdToActivityLog < ActiveRecord::Migration
  def change
    add_column :activity_logs, :commit_gh_id, :string, :default => nil
  end
end
