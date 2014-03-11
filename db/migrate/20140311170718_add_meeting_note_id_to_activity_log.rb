class AddMeetingNoteIdToActivityLog < ActiveRecord::Migration
  def change
    add_column :activity_logs, :meeting_note_id, :integer
  end
end
