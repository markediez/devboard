class CommitBelongsToDeveloperAccountNotDeveloper < ActiveRecord::Migration
  def change
    if DeveloperAccount.count > 0
      raise "Migration cannot run if any DeveloperAccount records exist."
    end

    rename_column :commits, :developer_id, :developer_account_id
  end
end
