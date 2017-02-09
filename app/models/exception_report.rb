class ExceptionReport < ApplicationRecord
  belongs_to :project
  belongs_to :task

  accepts_nested_attributes_for :task
end
