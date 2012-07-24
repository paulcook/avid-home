require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  
  def test_can_view_account
    login_as(:mandibal)
    get :index
    
    assert_response :success
  end
  
  def test_not_logged_in_cant_view_account
    get :index
    assert_response :redirect
    
    assert_redirected_to login_path
  end
  
  def test_should_activate_user
    assert_nil User.authenticate('aaron', 'test')
    get :activate, :id => users(:aaron).activation_code
    assert_redirected_to login_path
    assert_equal "Your account has been activated! You can now login.", flash[:notice]
    assert_equal users(:aaron), User.authenticate('aaron', 'test')
  end
  
  def test_should_not_activate_user_without_key
    get :activate
    assert_equal 'There was an error with the activation code. Please try creating a new account.',flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :activate, :id => ''
    assert_equal "Activation code not found. Please try creating a new account.",flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end
  
  def test_should_be_able_to_edit_account_details
    login_as(:quentin)
    get :edit, :id=>users(:quentin).login
    
    submit_form do |form|
      form.user.first_name = "Quent"
      form.user.last_name = "In"
      form.user.email = "quentinq@test.com"
      form.user.password = "newpass"
      form.user.password_confirmation = "newpass"
    end
    
    assert_response :redirect
    assert_redirected_to :accounts_path
    assert_equal User.encrypt("newpass",'salt'),assigns(:user).crypted_password
    assert_equal "quentinq@test.com",assigns(:user).email
  end
end
