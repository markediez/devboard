class RenameGitHubIssueIdToGitHubIssueNumber < ActiveRecord::Migration
  def change
    rename_column :tasks, :gh_issue_id, :gh_issue_number
  end
end
