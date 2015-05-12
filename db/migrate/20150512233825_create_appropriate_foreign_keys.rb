class CreateAppropriateForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :commits, :developer
    add_foreign_key :commits, :project

    add_foreign_key :developer_accounts, :developer

    add_foreign_key :meeting_notes, :project

    add_foreign_key :tasks, :developer
    add_foreign_key :tasks, :project

    add_foreign_key :users, :developer
  end
end
