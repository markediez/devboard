class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :assignments, :developer_account_id, :developer_id
  end
end
