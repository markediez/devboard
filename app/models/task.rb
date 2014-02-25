class Task < ActiveRecord::Base
  scope :active, -> { where(completed: nil) }
  
  belongs_to :developer
  belongs_to :project
  
  enum priority: [ :low_priority, :normal_priority, :high_priority ]
  
  validates_presence_of :developer, :project
end
