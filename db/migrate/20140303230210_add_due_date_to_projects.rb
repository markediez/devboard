class AddDueDateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :due, :date, :default => nil
  end
end
