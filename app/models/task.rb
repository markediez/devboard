# Duration is an integer in minutes.
class Task < ActiveRecord::Base
  scope :open, -> { where(completed_at: nil) }

  belongs_to :creator, :class_name => "DeveloperAccount"
  belongs_to :project
  has_one :assignment, :dependent => :destroy
  belongs_to :milestone

  enum priority: [ :low_priority, :normal_priority, :high_priority ]

  validates_presence_of :title, :priority

  # Difficulty is rated on a subjective scale from 1-10
  validates :difficulty, :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }, :allow_nil => true
end
