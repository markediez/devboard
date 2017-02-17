class Repository < ActiveRecord::Base
  belongs_to :project
  has_many :tasks
  has_many :commits

  validates_presence_of :project, :url
end
