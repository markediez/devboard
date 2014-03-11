class CreateMeetingNotes < ActiveRecord::Migration
  def change
    create_table :meeting_notes do |t|
      t.string :title
      t.text :body
      t.integer :project_id

      t.timestamps
    end
  end
end
