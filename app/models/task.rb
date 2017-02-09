# Duration is an integer in minutes.
class Task < ActiveRecord::Base
  scope :is_open, -> { where(completed_at: nil) }
  scope :is_closed, -> { where('completed_at is not null') }
  scope :is_unscored, -> { where(points: nil) }

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
    if self.gh_issue_number and self.repository and self.repository.url
      return 'https://github.com/' + self.repository.url + '/issues/' + self.gh_issue_number
    end

    return false
  end

  # Returns true if this task is 'GitHub-enabled', e.g. synced with GitHub, as opposed to
  # a task which exists solely in DevBoard.
  def github_enabled
    self.gh_issue_number.blank? == false
  end
end
