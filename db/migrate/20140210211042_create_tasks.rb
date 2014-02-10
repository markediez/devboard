class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :description
      t.integer :developer_id
      t.integer :project_id
      t.datetime :completed

      t.timestamps
    end
  end
end
