class ActivityLog < ActiveRecord::Base
  validates_presence_of :activity_type
  
  # Any of these may be nil
  belongs_to :developer
  belongs_to :project
  belongs_to :task
  
  before_create :set_when

  enum activity_type: [ :unspecified, :created ]

  protected

  def set_when
    self.when = Time.now
  end
end
