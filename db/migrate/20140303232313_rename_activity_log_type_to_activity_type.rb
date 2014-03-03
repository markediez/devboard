class RenameActivityLogTypeToActivityType < ActiveRecord::Migration
  def change
    rename_column :activity_logs, :type, :activity_type
  end
end
