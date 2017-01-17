class RestoreExceptionFromEmailToProjects < ActiveRecord::Migration[5.0]
  def change
    change_column :projects, :exception_from_email_id, :text
    rename_column :projects, :exception_from_email_id, :exception_email_from
  end
end
