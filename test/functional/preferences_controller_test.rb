require 'test_helper'

class PreferencesControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_can_view_preferences_edit
    login_as(:mandibal)
    get :edit, :user_id=>users(:mandibal).to_param
    assert_response :success
  end
  
  def test_cannot_view_prefrences_if_not_logged_in
    get :edit, :user_id=>users(:mandibal).to_param
    assert_response :redirect
    assert_redirected_to login_path
  end
end
