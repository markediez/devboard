class ImportStatus < ApplicationRecord
  validates_presence_of :task, :last_attempt
end
