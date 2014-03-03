class AddGitHubRepoUrlToApplication < ActiveRecord::Migration
  def change
    add_column :projects, :gh_repo_url, :string, :default => nil
  end
end
