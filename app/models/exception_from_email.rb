class ExceptionFromEmail < ApplicationRecord
  belongs_to :project
  has_many :exception_reports
end
