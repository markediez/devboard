require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  setup do
    CASClient::Frameworks::Rails::Filter.fake('casuser')
    session[:auth_via] = :cas
    session[:user_id] = 1
    session[:cas_user] = 'casuser'
  end
  
  # test "should get overview" do
  #   get :overview
  #   assert_response :success
  # end
end
