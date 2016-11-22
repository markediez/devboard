class AddRepositoryIdToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :repository_id, :int
  end
end
