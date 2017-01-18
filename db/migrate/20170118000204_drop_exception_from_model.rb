class DropExceptionFromModel < ActiveRecord::Migration[5.0]
  def change
    drop_table :exception_from_emails
  end
end
