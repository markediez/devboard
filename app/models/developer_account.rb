# Represents an online account a developer may have.
# Useful for collecting the activity of a single developer from multiple sources,
# or when they use multiple accounts at the same source (e.g. multiple e-mail addresses
# in various git commits)
class DeveloperAccount < ActiveRecord::Base
  validate :email, :minimum_email_length
  validates_inclusion_of :account_type, :in => %w( git github devboard )
  validate :support_only_one_github_per_developer

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

  # We purposefully only allow one GitHub account per developer at the moment so
  # our UI knows which GitHub DeveloperAccount to use when an assignment is graphically
  # dropped onto a developer in the Assignments Widget. Otherwise, we'd need to prompt the
  # user to ask which of the developer's GitHub accounts they want, and we do not currently
  # support that feature.
  def support_only_one_github_per_developer
    if account_type == 'github'
      if DeveloperAccount.where(account_type: 'github', developer_id: self.developer_id).count > 0
        errors.add(:developer_id, "Only one GitHub account per developer_id is permitted.")
      end
    end
  end
end
