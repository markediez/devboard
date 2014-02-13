class Task < ActiveRecord::Base
  scope :active, -> { where(completed: nil) }
  
  belongs_to :developer
  belongs_to :project
  
  validates_presence_of :developer, :project
end
