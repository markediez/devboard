# Duration is an integer in minutes.
class Task < ActiveRecord::Base
  scope :open, -> { where(completed_at: nil) }
  scope :closed, -> { where('completed_at is not null') }
  scope :unscored, -> { where(points: nil) }

  has_many :assignments, :class_name => "Assignment", :dependent => :destroy
  has_one :exception_report

  belongs_to :creator, :class_name => "DeveloperAccount"
  belongs_to :project
  belongs_to :repository
  belongs_to :milestone

  accepts_nested_attributes_for :assignments, :reject_if => lambda { |a| a[:developer_account_id].blank? }, :allow_destroy => true

  enum priority: [ :low_priority, :normal_priority, :high_priority ]

  validates_presence_of :title, :priority

  # Difficulty is rated on a subjective scale from 1-10
  validates :difficulty, :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }, :allow_nil => true

  # Returns the GitHub URL associated with this task, if any, else false
  def external_url
    if @task.gh_issue_number and @task.repository and @task.repository.url
      return 'https://github.com/' + @task.repository.url + '/issues/' + @task.gh_issue_number
    end

    return false
  end
end
