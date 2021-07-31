require "test_helper"

class UserLikesPostTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:fernando)
    @post = posts(:hola)
  end

  test "user likes a post" do
    assert_not @user.posts_liked.include?(@post)
    @user.likes.create(post: @post)
    assert @user.posts_liked.include?(@post)
  end

  
end
