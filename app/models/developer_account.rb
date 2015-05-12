# Represents an online account a developer may have.
# Useful for collecting the activity of a single developer from multiple sources,
# or when they use multiple accounts at the same source (e.g. multiple e-mail addresses
# in various git commits)
class DeveloperAccount < ActiveRecord::Base
  validates :email, length: { minimum: 5 }
  validates_presence_of :developer
  validates_inclusion_of :account_type, :in => %w( git )

  belongs_to :developer
end
