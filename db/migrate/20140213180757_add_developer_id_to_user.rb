class AddDeveloperIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :developer_id, :integer, :default => nil
  end
end
