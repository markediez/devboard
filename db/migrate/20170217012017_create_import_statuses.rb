class CreateImportStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :import_statuses do |t|
      t.string :task, null: false
      t.date :last_attempt, null: false
      t.date :last_success

      t.timestamps
    end
  end
end
