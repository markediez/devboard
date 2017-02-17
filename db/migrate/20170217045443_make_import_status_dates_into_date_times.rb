class MakeImportStatusDatesIntoDateTimes < ActiveRecord::Migration[5.0]
  def change
    change_column :import_statuses, :last_attempt, :datetime, null: false
    change_column :import_statuses, :last_success, :datetime, null: true
  end
end
