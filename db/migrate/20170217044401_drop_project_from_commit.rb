class DropProjectFromCommit < ActiveRecord::Migration[5.0]
  def change
    remove_column :commits, :project_id
  end
end
