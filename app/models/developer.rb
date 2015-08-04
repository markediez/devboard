# A developer typically owns a task or an issue. Not necessarily able to log into
# Devboard (that requires a User object).
class Developer < ActiveRecord::Base
  # Tasks this developer created
  has_many :created_tasks, :class_name => "Task", :foreign_key => "creator_id"
  # # Tasks this developer has been assigned
  # has_many :assigned_tasks, :class_name => "Task", :foreign_key => "assignee_id"

  has_many :assignments

  # loginid may not exist in the case of a GH commit imported with no 'loginid'
  validates_uniqueness_of :loginid
  validate :github_requires_two_fields

  has_one :user # nullable
  has_many :accounts, :class_name => "DeveloperAccount"

  def to_param
    if name.nil?
      return id.to_s
    else
      return [id, name.parameterize].join("-")
    end
  end

  # Return all commits for all accounts associated with this Developer
  def commits
    Commit.where developer_account_id: accounts.map{ |a| a.id }
  end

  def open_assignments
    assignments.where("completed_at is null") #.where("assigned_at <= '#{Time.now.utc}'").where("completed_at is null")
  end

  protected

  # gh_username and gh_personal_token are optional but both must be present if either is specified
  def github_requires_two_fields
    if not gh_username.blank? and gh_personal_token.blank?
      errors.add(:gh_personal_token, "Must be specified if GitHub username is specified")
    end
    if gh_username.blank? and not gh_personal_token.blank?
      errors.add(:gh_username, "Must be specified if GitHub Personal Access Token is specified")
    end
  end
end
