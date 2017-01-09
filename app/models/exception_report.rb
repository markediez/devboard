class ExceptionReport < ApplicationRecord
  belongs_to :project
  belongs_to :task
  belongs_to :exception_from_email
end
