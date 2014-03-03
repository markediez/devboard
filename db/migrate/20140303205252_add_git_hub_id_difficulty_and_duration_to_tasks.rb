class AddGitHubIdDifficultyAndDurationToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :difficulty, :integer, :default => nil
    add_column :tasks, :duration, :integer, :default => nil
    add_column :tasks, :gh_issue_id, :string, :default => nil
  end
end
