class RemoveEmailFromIdInExceptionReports < ActiveRecord::Migration[5.0]
  def change
    remove_column :exception_reports, :exception_from_email_id
  end
end
