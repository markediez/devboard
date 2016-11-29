class RemoveColumnGhRepoUrlFromProjects < ActiveRecord::Migration[5.0]
  def change
    remove_column :projects, :gh_repo_url
  end
end
