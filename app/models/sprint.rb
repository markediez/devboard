class Sprint < ActiveRecord::Base
  belongs_to :milestone
  
  validates_presence_of :milestone
end
