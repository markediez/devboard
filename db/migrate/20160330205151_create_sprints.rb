class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.integer :milestone_id
      t.datetime :started_at
      t.datetime :finished_at
      t.float :points_attempted
      t.float :points_completed

      t.timestamps null: false
    end
  end
end
