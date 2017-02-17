class Assignment < ActiveRecord::Base
  belongs_to :developer_account
  belongs_to :task

  before_validation :set_sort_position_if_necessary
  before_create :set_assigned_at

  validates_presence_of :developer_account, :task
  validates_uniqueness_of :task_id, :scope => :developer_account_id

  validate :github_task_must_belong_to_github_account
  validate :sort_position_must_be_unique_with_developer_id

  validates_presence_of :sort_position

  def developer
    developer_account.developer.present? ? developer_account.developer : nil
  end

  # Returns the number of days left for the assignment.
  # A negative value indicates the assignment is overdue or completed.
  def due_in_days
    (due_at - Time.now) / 86400 # 86400 is the number of seconds in 1 day (24 hours)
  end

  private

  def set_sort_position_if_necessary
    self.sort_position = Assignment.maximum(:sort_position) + 1 unless self.sort_position
  end

  # assigned_at is essentially created_at but we allow it to differ in case
  # we import an assignment from an external system and need to change the assigned_at
  # date without conflating it with when the SQL record was created in our system (created_at)
  def set_assigned_at
    if assigned_at == nil
      self.assigned_at = Time.now
    end
  end

  def github_task_must_belong_to_github_account
    if developer_account.present? and task.present? and task.gh_issue_number.present?
      if developer_account.account_type != 'github'
        errors.add :developer_account_id, "GitHub-linked task can only be assigned to a GitHub-linked developer account."
      end
    end
  end

  def sort_position_must_be_unique_with_developer_id
    if developer
      count = Assignment.includes(:developer_account).includes(:task).where.not( id: self.id ).where(:sort_position => self.sort_position).where(:tasks => { completed_at: nil }).where(:developer_accounts => { :developer_id => self.developer.id }).count
    else
      count = Assignment.includes(:developer_account).includes(:task).where.not( id: self.id ).where(:sort_position => self.sort_position).where(:tasks => { completed_at: nil }).where(:developer_account_id => self.developer_account_id).count
    end

    if count > 0
      errors.add(:sort_position, "Must be unique for this developer")
    end
  end
end
