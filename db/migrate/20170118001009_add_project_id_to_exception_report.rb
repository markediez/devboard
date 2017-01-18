class AddProjectIdToExceptionReport < ActiveRecord::Migration[5.0]
  def change
    add_column :exception_reports, :project_id, :integer
  end
end
