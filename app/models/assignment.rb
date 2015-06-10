class Assignment < ActiveRecord::Base
  belongs_to :developer
  belongs_to :task
end
