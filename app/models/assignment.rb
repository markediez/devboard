class Assignment < ActiveRecord::Base
  belongs_to :developer_account
  belongs_to :task
  before_create :set_assigned_at

  def developer
    developer_account.present? ? developer_account.developer : nil
  end

  # Returns the number of days left for the assignment.
  # A negative value indicates the assignment is overdue or completed.
  def due_in_days
    (due_at - Time.now) / 86400 # 86400 is the number of seconds in 1 day (24 hours)
  end

  private

  # assigned_at is essentially created_at but we allow it to differ in case
  # we import an assignment from an external system and need to change the assigned_at
  # date without conflating it with when the SQL record was created in our system (created_at)
  def set_assigned_at
    if assigned_at == nil
      assigned_at = Time.now
    end
  end
end
