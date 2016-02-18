class AddActiveFlagToDevelopers < ActiveRecord::Migration
  def change
    add_column :developers, :active, :boolean, default: true
  end
end
