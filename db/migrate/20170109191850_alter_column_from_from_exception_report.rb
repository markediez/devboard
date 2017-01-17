class AlterColumnFromFromExceptionReport < ActiveRecord::Migration[5.0]
  def change
    change_column :exception_reports, :from, :int
    rename_column :exception_reports, :from, :exception_from_email_id
  end
end
