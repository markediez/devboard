class ProjectsBeganShouldBeDateTime < ActiveRecord::Migration
  def change
    change_column :projects, :began, :datetime
  end
end
