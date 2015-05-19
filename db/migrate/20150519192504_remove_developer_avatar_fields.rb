class RemoveDeveloperAvatarFields < ActiveRecord::Migration
  def change
    remove_column :developers, :avatar_file_name
    remove_column :developers, :avatar_file_type
    remove_column :developers, :avatar_file_size
    remove_column :developers, :avatar_uploaded_at
  end
end
