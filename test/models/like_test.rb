require "test_helper"

class LikeTest < ActiveSupport::TestCase
  def setup 
    @user = users(:fernando)
    @post = posts(:hola)
  end

  test "user likes a post" do
    assert_not @user.like_post? @post
    @user.like_post @post
    assert @user.like_post? @post
  end
  
  test "user dislikes a post" do
    assert_not @user.dislike_post? @post
    @user.dislike_post @post
    assert @user.dislike_post? @post
  end

  test "user likes a post and then doesn't like it" do
    @user.like_post @post
    assert @user.like_post? @post
    assert_not @user.dislike_post? @post
    @user.dislike_post @post
    assert @user.dislike_post? @post
    assert_not @user.like_post? @post
  end

  test "user dislikes a post and then like it" do
    @user.dislike_post @post
    assert @user.dislike_post? @post
    assert_not @user.like_post? @post
    @user.like_post @post
    assert @user.like_post? @post
    assert_not @user.dislike_post? @post
  end

  test "user likes a post only one time" do
    @user.like_post @post
    @user.like_post @post
    assert @user.like_post? @post
    arr = @user.posts_liked.select{ |p| p == @post }
    assert_equal arr.length, 1
    assert_equal arr[0], @post
    arr = @user.posts_disliked.select { |p| p == @post }
    assert_equal arr.length, 0

    @user.dislike_post @post
    @user.dislike_post @post
    assert @user.dislike_post? @post
    arr = @user.posts_disliked.select { |p| p == @post }
    assert_equal arr.length, 1
    assert_equal arr[0], @post
    arr = @user.posts_liked.select { |p| p == @post }
    assert_equal arr.length, 0
  end
end
