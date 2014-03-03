class Project < ActiveRecord::Base
  scope :active, -> { where('status not in (4, 5)') }
  scope :inactive, -> { where('status in (4, 5)') }
  
  enum status: [ :planning, :in_development, :pilot_testing, :in_production, :cancelled, :on_hold ]
  enum priority: [ :low_priority, :normal_priority, :high_priority ]
  
  has_many :tasks
  
  # Parses gh_repo_url and extracts either the username or repo name
  def gh_repo_url_parse(selector)
    user, ignore, project = gh_repo_url.rpartition('/')
    
    case selector
    when :user
      return user
    when :project
      return project
    end
    
    return nil
  end
end
