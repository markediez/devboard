class ExceptionReportsBelongToTheirEmail < ActiveRecord::Migration[5.0]
  def change
    ExceptionReport.all.each do |er|
      er.exception_from_email = er.project.exception_from_email
      er.save
    end
  end
end
