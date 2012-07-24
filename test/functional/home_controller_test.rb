require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_can_view_home_page
    get :index
    assert_response :success
  end
  
  def test_loggged_in_gets_redirected_to_account
    login_as(:mandibal)
    get :index
    assert_response :redirect
    assert_redirected_to accounts_path
  end
  
  def test_can_view_about_page
    get :about
    assert_response :success
  end
  
  def test_can_view_help_page
    get :help
    assert_response :success
  end
  
  def test_can_view_about_page_logged_in
    login_as(:mandibal)
    get :about
    assert_response :success
  end
  
  def test_can_view_help_page_logged_in
    login_as(:mandibal)
    get :help
    assert_response :success
  end

end
