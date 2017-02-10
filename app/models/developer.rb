# A developer typically owns a task or an issue. Not necessarily able to log into
# Devboard (that requires a User object).
class Developer < ActiveRecord::Base
  after_save :create_devboard_developer_account
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
    # Query all assignments in order
    assignments = []

    Assignment.where(:developer_account_id => accounts.ids).each do |a|
      if only_open
        assignments << a unless a.task.completed_at
      else
        assignments << a
      end
    end

    #assignments.sort!{|x, y| x.task.sort_position <=> y.task.sort_position}

    return assignments.flatten
  end

  # Returns the assignments open or completed for this developer on the given date
  # If an assignment was closed before this date or added after this date, it will
  # not appear.
  #
  # Logic:
  # assignments made this day or before
  # assignments not completed or completed this day or after
  def assignments_at(date)
    start_of_day = date.change(:hour => 0)
    end_of_day = date.change(:hour => 24)

    Assignment.joins(:task).where(:developer_account_id => self.accounts.map{|a| a.id} ).where('assigned_at < ?', end_of_day ).where( :tasks => { :completed_at => [nil, start_of_day...end_of_day] } )
  end

  def devboard_account
    accounts.where(:account_type => "devboard").first
  end

  def devboard_account_id
    return nil unless self.devboard_account.present?
    return self.devboard_account.id
  end

  protected

  def create_devboard_developer_account
    unless devboard_account.present?
      da = DeveloperAccount.new
      da.developer = self
      da.email = self.email
      da.loginid = self.loginid
      da.name = self.name
      da.account_type = "devboard"
      da.save!
    end
  end

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
