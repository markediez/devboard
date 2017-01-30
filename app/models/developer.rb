# A developer typically owns a task or an issue. Not necessarily able to log into
# Devboard (that requires a User object).
class Developer < ActiveRecord::Base
  # Tasks this developer created
  has_many :created_tasks, :class_name => "Task", :foreign_key => "creator_id"

  # loginid may not exist in the case of a GH commit imported with no 'loginid'
  validates_uniqueness_of :loginid
  validate :github_requires_two_fields

  has_one :user # nullable as not all developers have user accounts
  has_many :accounts, :class_name => "DeveloperAccount"
  has_many :assignments

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

  def assignments(only_open: false)
    assignments = []

    accounts.each do |account|
      if only_open
        account.assignments.each do |assignment|
          assignments << assignment unless assignment.task.completed_at
        end
      else
        assignments << account.assignments
      end
    end

    return assignments.flatten
  end

  def assignments_at(date)
    start_of_day = date.change(:hour => 0)
    end_of_day = date.change(:hour => 24)

    assignments_to_view = assignments
    assignments.each do |a|
      task = a.task
      logger.debug "~~" + a.task.title
      if task.completed_at && (task.completed_at > end_of_day || task.completed_at < start_of_day)
        logger.debug "BOOM"
        assignments_to_view.delete(a)
      end
    end

    return assignments_to_view
    #
    # logger.debug "============="
    # logger.debug start_of_day
    # logger.debug end_of_day
    # valid_assignments = assignments
    # valid_assignments.each do |a|
    #   logger.debug "~~" + a.task.title
    #   if a.task.completed_at && (a.task.completed_at < start_of_day || a.task.completed_at > end_of_day)
    #     logger.debug "yes"
    #     logger.debug  "::" + a.task.completed_at.to_s
    #     valid_assignments.delete(a)
    #   end
    # end
    #
    # return valid_assignments
  end

  def devboard_account
    accounts.each do |account|
      return account if account.account_type == "devboard"
    end
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
