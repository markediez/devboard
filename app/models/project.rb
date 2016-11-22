class Project < ActiveRecord::Base
  scope :active, -> { where('status not in (4, 5)') }
  scope :inactive, -> { where('status in (4, 5)') }

  enum status: [ :planning, :in_development, :pilot_testing, :in_production, :cancelled, :on_hold ]
  enum priority: [ :low_priority, :normal_priority, :high_priority ]

  validates_presence_of :name

  has_many :tasks
  has_many :meeting_notes
  has_many :commits
  has_many :milestones
  has_many :repositories, :class_name => "Repository", :dependent => :destroy

  accepts_nested_attributes_for :repositories, :reject_if => lambda { |a| a[:gh_url].blank? }, :allow_destroy => true

  def to_param
    [id, name.parameterize].join("-")
  end

  # Parses gh_repo_url and extracts either the username, repo name, or both
  def gh_repo_url_parse(selector = nil)
    return nil if gh_repo_url.blank?

    user, ignore, project = gh_repo_url.rpartition('/')

    case selector
    when :user
      return user
    when :project
      return project
    when :both
      return user + '/' + project
    else
      return user, project
    end

    return nil
  end
end
