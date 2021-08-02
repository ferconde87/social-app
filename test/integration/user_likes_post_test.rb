require "test_helper"

class UserLikesPostTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:fernando)
    @post = posts(:hola)
  end

  test "user likes a post" do
    assert_not @user.like?(@post)
    likes_before = @post.likes_count
    dislikes_before = @post.dislikes_count
    assert_difference 'Like.count', 1 do
      @user.like_post @post
    end
    assert @user.like?(@post)
    @post.reload
    assert_equal likes_before+1, @post.likes_count
    assert_equal dislikes_before, @post.dislikes_count
  end
end
