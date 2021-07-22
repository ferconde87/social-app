require 'test_helper'
class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:michael)
    remember(@user)
    @fer = users(:fernando)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end
  
  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

  test "when current user id doesn't match session user id, is not logged in" do
    current_user = @fer
    assert_not logged_in?
  end

  test "when session user_id is invalid, nobody is logged in" do
    session[:user_id] = "something_invalid"
    assert_not logged_in?
  end
end
  