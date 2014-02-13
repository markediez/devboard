class Project < ActiveRecord::Base
  scope :active, -> { where(finished: nil).where('status not in (4, 5)') }
  
  enum status: [ :planning, :in_development, :pilot_testing, :in_production, :cancelled, :on_hold ]
  enum priority: [ :low_priority, :normal_priority, :high_priority ]
  
  has_many :tasks
end
