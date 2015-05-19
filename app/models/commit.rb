# Represents a code commit
# Originally designed to be imported from GitHub
class Commit < ActiveRecord::Base
  validates :sha, length: { is: 40 }

  validates_presence_of :project
  validates_presence_of :message
  validates_presence_of :committed_at
  validates_presence_of :account

  belongs_to :account, :class_name => "DeveloperAccount"
  belongs_to :project
end
