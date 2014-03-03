class AddGitHubPersonalTokenToDeveloper < ActiveRecord::Migration
  def change
    add_column :developers, :gh_personal_token, :string, :default => nil
  end
end
