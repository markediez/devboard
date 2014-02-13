# User class. Holds information about user logins. Optionally linked to a developer account.
class User < ActiveRecord::Base
  validates_presence_of :loginid
  validates_uniqueness_of :loginid
  
  belongs_to :developer # may be nil
end
