class AddAvatarToDeveloper < ActiveRecord::Migration
  def self.up
    add_attachment :developers, :avatar
  end

  def self.down
    remove_attachment :developers, :avatar
  end
end
