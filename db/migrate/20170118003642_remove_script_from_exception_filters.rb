class RemoveScriptFromExceptionFilters < ActiveRecord::Migration[5.0]
  def change
    remove_column :exception_filters, :script
    add_column :exception_filters, :kind, :string
    add_column :exception_filters, :value, :string
  end
end
