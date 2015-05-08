# Represents a code commit
# Originally designed to be imported from GitHub
class Commit < ActiveRecord::Base
  validates :sha, length: { is: 40 }

  validates_presence_of :project
  validates_presence_of :message
  validates_presence_of :committed_at

  belongs_to :developer
  belongs_to :project
end
