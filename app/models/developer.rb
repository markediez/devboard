class Developer < ActiveRecord::Base
  has_many :tasks
  validates_uniqueness_of :loginid
  validates_presence_of :name, :loginid, :email
  
  has_attached_file :avatar, :styles => { :small => "55x55>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  has_one :user # may be nil
end
