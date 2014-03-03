module TasksHelper
  def gh_available
    current_user.developer and not current_user.developer.gh_personal_token.blank? and not current_user.developer.gh_username.blank?
  end
end
