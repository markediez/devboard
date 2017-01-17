class AddFromToExceptionReport < ActiveRecord::Migration[5.0]
  def change
    add_column :exception_reports, :from, :text
  end
end
