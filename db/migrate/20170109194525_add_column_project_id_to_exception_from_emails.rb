class AddColumnProjectIdToExceptionFromEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :exception_from_emails, :project_id, :int
  end
end
