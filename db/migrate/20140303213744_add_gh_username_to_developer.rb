class AddGhUsernameToDeveloper < ActiveRecord::Migration
  def change
    add_column :developers, :gh_username, :string, :default => nil
  end
end
