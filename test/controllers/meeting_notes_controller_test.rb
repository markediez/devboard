require 'test_helper'

class MeetingNotesControllerTest < ActionController::TestCase
  setup do
    @meeting_note = meeting_notes(:one)
    CASClient::Frameworks::Rails::Filter.fake('casuser')
    session[:auth_via] = :cas
    session[:user_id] = 1
    session[:cas_user] = 'casuser'
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:meeting_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create meeting_note" do
    assert_difference('MeetingNote.count') do
      post :create, meeting_note: { body: @meeting_note.body, project_id: @meeting_note.project_id, title: @meeting_note.title }
    end

    assert_redirected_to meeting_note_path(assigns(:meeting_note))
  end

  test "should show meeting_note" do
    get :show, id: @meeting_note
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @meeting_note
    assert_response :success
  end

  test "should update meeting_note" do
    patch :update, id: @meeting_note, meeting_note: { body: @meeting_note.body, project_id: @meeting_note.project_id, title: @meeting_note.title }
    assert_redirected_to meeting_note_path(assigns(:meeting_note))
  end

  test "should destroy meeting_note" do
    assert_difference('MeetingNote.count', -1) do
      delete :destroy, id: @meeting_note
    end

    assert_redirected_to meeting_notes_path
  end
end
