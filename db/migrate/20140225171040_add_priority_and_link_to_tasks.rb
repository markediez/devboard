class AddPriorityAndLinkToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :link, :string
    add_column :tasks, :priority, :integer
  end
end
