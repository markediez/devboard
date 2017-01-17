class AlterColumnDuplicateFromExceptionReports < ActiveRecord::Migration[5.0]
  def change
    change_column :exception_reports, :duplicate, :int

    # Make sure the column is "refreshed"
    ExceptionReport.all.each do |er|
      er.duplicate = nil
      er.save!
    end

    rename_column :exception_reports, :duplicate, :original_id
  end
end
