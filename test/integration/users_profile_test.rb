require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:fernando)
    log_in_as(@user)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'span', text: @user.name
    assert_select 'img.gravatar'
    assert_match @user.posts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.posts.paginate(page: 1).each do |post|
      assert_match post.content, response.body
    end
    assert_select 'strong#following', text: @user.following.count.to_s
    assert_select 'strong#followers', text: @user.followers.count.to_s
  end
end
