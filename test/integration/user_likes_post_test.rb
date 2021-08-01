require "test_helper"

class UserLikesPostTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:fernando)
    @post = posts(:hola)
  end

  test "user likes a post" do
    assert_not @user.like?(@post)
    @user.like_post @post
    assert @user.like?(@post)
  end
end
