module ApplicationHelper
  include Authentication
  
  def authenticated?
    not current_user.nil?
  end
end
