class RemoveMessageFromActivityLogAndAddType < ActiveRecord::Migration
  def change
    remove_column :activity_logs, :message
    add_column :activity_logs, :type, :integer, default: 0
  end
end
