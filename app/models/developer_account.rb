# Represents an online account a developer may have.
# Useful for collecting the activity of a single developer from multiple sources,
# or when they use multiple accounts at the same source (e.g. multiple e-mail addresses
# in various git commits)
class DeveloperAccount < ActiveRecord::Base
  validate :email, :minimum_email_length
  validates_inclusion_of :account_type, :in => %w( git github devboard )

  belongs_to :developer
  has_many :commits
  has_many :assignments

  def developer_name
    developer.present? ? developer.name : self.name
  end

  private

  def minimum_email_length
    unless self.email.nil?
      if self.email.length < 5
        errors.add(:email, "e-mail address should be at least five characters")
      end
    end
  end
end
