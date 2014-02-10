class Project < ActiveRecord::Base
  enum status: [ :planning, :in_progress, :finished, :canceled, :on_hold ]
  enum priority: [ :low_priority, :normal_priority, :high_priority ]
  
  has_many :tasks
end
