class AddExceptionEmailFromToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :exception_email_from, :string, :null => true
  end
end
