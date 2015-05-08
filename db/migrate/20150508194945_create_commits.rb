class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :sha
      t.integer :developer_id
      t.integer :project_id
      t.string :message

      t.timestamps
    end
  end
end
