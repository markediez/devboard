class ChangeAssignmentsBackToDeveloperAccounts < ActiveRecord::Migration[5.0]
  def change
    rename_column :assignments, :developer_id, :developer_account_id
  end
end
