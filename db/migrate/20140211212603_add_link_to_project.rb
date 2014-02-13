class AddLinkToProject < ActiveRecord::Migration
  def change
    add_column :projects, :link, :string, :default => nil
  end
end
