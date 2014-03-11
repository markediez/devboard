class AddTakenFieldToMeetingNotes < ActiveRecord::Migration
  def change
    add_column :meeting_notes, :taken, :datetime
  end
end
