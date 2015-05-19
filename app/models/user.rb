# A user is somebody who can log into Devboard. Optionally linked to a developer account.
class User < ActiveRecord::Base
  validates_presence_of :loginid
  validates_uniqueness_of :loginid

  belongs_to :developer # nullable
end
