class Assignment < ActiveRecord::Base
  belongs_to :developer_account
  belongs_to :task

  # Returns the number of days left for the assignment.
  # A negative value indicates the assignment is overdue or completed.
  def due_in_days
    (due_at - Time.now) / 86400 # 86400 is the number of seconds in 1 day (24 hours)
  end
end
