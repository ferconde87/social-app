require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user_not_valid_yet = users(:user_not_valid_yet)
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: {  name: "",
                                          email: "user@invalid",
                                          password: "foo",
                                          password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div.alert.alert-danger'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
    post users_path, params: { user: {  name: "Example User",
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
  # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?    
    # assert_not flash.empty?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

  test "sign up with activated user due to using 3th-party sign up" do
    @user_not_valid_yet = User.new(name: "pepe", email: "pepe@pepe.com", activated: "true")
    assert_not @user_not_valid_yet.valid?
    get "/users/new"
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {  
          name: @user_not_valid_yet.name,
          email: @user_not_valid_yet.email,  
          password: "password",
          password_confirmation: "password",
          activated: true },
        activated: true }
    end
    @user = assigns(:user)
    assert @user.valid?
    assert logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'div.alert.alert-success'
  end
end
