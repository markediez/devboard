class AddEmailFromToExceptionReport < ActiveRecord::Migration[5.0]
  def change
    add_column :exception_reports, :email_from, :string
  end
end
