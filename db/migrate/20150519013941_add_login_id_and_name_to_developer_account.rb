class AddLoginIdAndNameToDeveloperAccount < ActiveRecord::Migration
  def change
    add_column :developer_accounts, :loginid, :string
    add_column :developer_accounts, :name, :string
  end
end
