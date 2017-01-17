class AlterColumnExceptionEmailFromFromProject < ActiveRecord::Migration[5.0]
  def change
    change_column :projects, :exception_email_from, :int
    rename_column :projects, :exception_email_from, :exception_from_email_id
  end
end
