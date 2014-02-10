class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :status
      t.date :began
      t.date :finished
      t.integer :priority

      t.timestamps
    end
  end
end
