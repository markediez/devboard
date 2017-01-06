class AddTaskIdToExceptionReport < ActiveRecord::Migration[5.0]
  def change
    add_column :exception_reports, :task_id, :int
  end
end
