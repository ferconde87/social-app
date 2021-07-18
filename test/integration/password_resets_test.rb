require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:fernando)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_select 'div.alert.alert-danger'
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.password_reset_digest, @user.reload.password_reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.password_reset_token, email: "")
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.password_reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.password_reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    patch password_reset_path(user.password_reset_token), 
    params: { 
      email: user.email,
      user: { 
        password: "foobaz",
        password_confirmation: "barquux" 
      } 
    }
    assert_select 'div.alert.alert-danger'
    # Empty password
    patch password_reset_path(user.password_reset_token), 
    params: { 
      email: user.email,
      user: { 
        password: "",
        password_confirmation: "" 
      } 
    }
    assert_select 'div.alert.alert-danger'
    # Valid password & confirmation
    patch password_reset_path(user.password_reset_token),
    params: { 
      email: user.email,
      user: { 
        password: "new_password_ok",
        password_confirmation: "new_password_ok" 
      } 
    }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, 
      params: { password_reset: { email: @user.email } }
    @user = assigns(:user)
    @user.update_attribute(:password_reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.password_reset_token),
    params: { 
      email: @user.email,
      user: { 
        password: "foobar",
        password_confirmation: "foobar" 
      } 
    }
    assert_response :redirect
    follow_redirect!
    assert_not flash.empty?
    assert_select 'div.alert.alert-danger'
    assert_match "Password reset has expired", response.body
  end

  test "after reseting the password, the password_reset_digest is nil" do
    get new_password_reset_path
    post password_resets_path, 
      params: { password_reset: { email: @user.email } }
    @user = assigns(:user)
    patch password_reset_path(@user.password_reset_token),
    params: { 
      email: @user.email,
      user: { 
        password: "new_password_ok",
        password_confirmation: "new_password_ok" 
      }
    }
    assert_nil(@user.reload.password_reset_digest)
  end
end
