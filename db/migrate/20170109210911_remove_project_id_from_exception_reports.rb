class RemoveProjectIdFromExceptionReports < ActiveRecord::Migration[5.0]
  def change
    remove_column :exception_reports, :project_id
  end
end
