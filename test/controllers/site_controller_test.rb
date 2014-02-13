require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  test "should get overview" do
    get :overview
    assert_response :success
  end

end
