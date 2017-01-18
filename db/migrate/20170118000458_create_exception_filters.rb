class CreateExceptionFilters < ActiveRecord::Migration[5.0]
  def change
    create_table :exception_filters do |t|
      t.string :field
      t.string :value

      t.timestamps
    end
  end
end
