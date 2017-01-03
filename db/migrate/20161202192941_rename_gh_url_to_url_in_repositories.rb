class RenameGhUrlToUrlInRepositories < ActiveRecord::Migration[5.0]
  def change
    rename_column :repositories, :gh_url, :url
  end
end
