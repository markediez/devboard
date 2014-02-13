require 'test_helper'

class DevelopersControllerTest < ActionController::TestCase
  setup do
    @developer = developers(:picard)
    CASClient::Frameworks::Rails::Filter.fake('casuser')
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:developers)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should create developer" do
    assert_difference('Developer.count') do
      # Need to modify @developer as this CREATE will fail - it's already in the database by the nature of being in a fixture
      post :create, developer: { email: 'new-' + @developer.email, loginid: @developer.loginid + 'new', name: @developer.name + 'new' }
    end
  
    assert_redirected_to developer_path(assigns(:developer))
  end
  
  test "should show developer" do
    get :show, id: @developer
    assert_response :success
  end
  
  test "should get edit" do
    get :edit, id: @developer
    assert_response :success
  end
  
  test "should update developer" do
    patch :update, id: @developer, developer: { email: @developer.email, loginid: @developer.loginid, name: @developer.name }
    assert_redirected_to developer_path(assigns(:developer))
  end
  
  test "should destroy developer" do
    assert_difference('Developer.count', -1) do
      delete :destroy, id: @developer
    end
  
    assert_redirected_to developers_path
  end
end
