require "test_helper"

class LikeTest < ActiveSupport::TestCase
  def setup 
    @user = users(:fernando)
    @post = posts(:hola)
  end

  test "user likes a post" do
    assert_not @user.like? @post
    @user.like @post
    assert @user.like? @post
  end
  
  test "user dislikes a post" do
    assert_not @user.dislike? @post
    @user.dislike @post
    assert @user.dislike? @post
  end

  test "user likes a post and then doesn't like it" do
    @user.like @post
    assert @user.like? @post
    assert_not @user.dislike? @post
    @user.dislike @post
    assert @user.dislike? @post
    assert_not @user.like? @post
  end

  test "user dislikes a post and then like it" do
    @user.dislike @post
    assert @user.dislike? @post
    assert_not @user.like? @post
    @user.like @post
    assert @user.like? @post
    assert_not @user.dislike? @post
  end

  test "user likes a post only one time" do
    @user.like @post
    @user.like @post
    assert @user.like? @post
    arr = @user.posts_liked.select{ |p| p == @post }
    assert_equal arr.length, 1
    assert_equal arr[0], @post
    arr = @user.posts_disliked.select { |p| p == @post }
    assert_equal arr.length, 0

    @user.dislike @post
    @user.dislike @post
    assert @user.dislike? @post
    arr = @user.posts_disliked.select { |p| p == @post }
    assert_equal arr.length, 1
    assert_equal arr[0], @post
    arr = @user.posts_liked.select { |p| p == @post }
    assert_equal arr.length, 0
  end
end
