class ChangeAssignmentDeveloperToDeveloperAccount < ActiveRecord::Migration
  def change
    rename_column :assignments, :developer_id, :developer_account_id
  end
end
