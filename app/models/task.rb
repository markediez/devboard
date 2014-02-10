class Task < ActiveRecord::Base
  belongs_to :developer
  belongs_to :project
end
