class ApiKeyUser < ActiveRecord::Base
  
  # Ensures name and secret are unique and present
  validates :name, :uniqueness => true, :presence => true
  validates :secret, :uniqueness => true, :presence => true

  before_validation :ensure_secret_exists

  # Generates a new secret for a new user
  def ensure_secret_exists
    if secret.nil?
      self.secret = generate_secret
    end
  end

  def generate_secret
    Digest::MD5.hexdigest('100115115105116' + Time.now.to_i.to_s)
  end

end
