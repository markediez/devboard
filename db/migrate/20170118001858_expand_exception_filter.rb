class ExpandExceptionFilter < ActiveRecord::Migration[5.0]
  def change
    rename_column :exception_filters, :field, :concern
    rename_column :exception_filters, :value, :pattern
    add_column :exception_filters, :script, :text
  end
end
