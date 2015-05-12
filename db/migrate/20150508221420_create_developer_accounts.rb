class CreateDeveloperAccounts < ActiveRecord::Migration
  def change
    create_table :developer_accounts do |t|
      t.integer :developer_id
      t.string :email
      t.string :account_type

      t.timestamps
    end
  end
end
