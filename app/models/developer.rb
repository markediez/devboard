class Developer < ActiveRecord::Base
  has_many :tasks
  
  validates_uniqueness_of :loginid
  validates_presence_of :name, :loginid, :email
  validate :github_requires_two_fields
  
  has_attached_file :avatar, :styles => { :small => "55x55>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  has_one :user # may be nil
  
  protected
  
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
