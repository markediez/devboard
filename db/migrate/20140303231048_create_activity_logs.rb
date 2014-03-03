class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.integer :developer_id
      t.integer :project_id
      t.datetime :when
      t.string :message
    end
  end
end
