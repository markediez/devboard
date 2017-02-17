class AddRepositoryIdToCommit < ActiveRecord::Migration[5.0]
  def change
    add_column :commits, :repository_id, :integer, null: false, default: 0
  end
end
