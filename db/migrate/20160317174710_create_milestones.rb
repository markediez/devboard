class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.string :title
      t.text :description
      t.datetime :due_on
      t.datetime :completed_at
      t.integer :gh_milestone_number

      t.timestamps null: false
    end
  end
end
