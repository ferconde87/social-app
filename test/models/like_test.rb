require "test_helper"

class LikeTest < ActiveSupport::TestCase
  def setup 
    @user = users(:fernando)
    @post = posts(:hola)
    @bob = users(:bob)
    @comment = comments(:hola)
  end

  test "user likes a post" do
    assert_not Like.like?(@user, @post)
    Like.like(@user, @post)
    assert Like.like?(@user, @post)
  end
  
  test "user dislikes a post" do
    assert_not Like.dislike?(@user, @post)
    Like.dislike(@user, @post)
    assert Like.dislike?(@user, @post)
  end

  test "user likes a post and then does not like it" do
    Like.like(@user, @post)
    assert Like.like?(@user, @post)
    assert_not Like.dislike?(@user, @post)
    Like.dislike(@user, @post)
    assert Like.dislike?(@user, @post)
    # assert_not @user.reload.like? @post
  end

  test "user dislikes a post and then like it" do
    Like.dislike(@user, @post)
    assert Like.dislike?(@user, @post)
    assert_not Like.like?(@user, @post)
    Like.like(@user, @post)
    assert Like.like?(@user, @post)
    assert_not Like.dislike?(@user, @post)
  end

  test "user likes a post only one time" do
    assert 0, @post.likes_count
    Like.like(@user, @post)
    Like.like(@user, @post)
    assert Like.like?(@user, @post)
    # arr = @user.posts_liked.select{ |p| p == @post }
    # assert_equal arr.length, 1
    # assert_equal arr[0], @post
    # arr = @user.posts_disliked.select { |p| p == @post }
    # assert_equal arr.length, 0
    assert_equal 1, @post.likes_count
    assert_equal 0, @post.dislikes_count

    Like.dislike(@user, @post)
    Like.dislike(@user, @post)
    assert Like.dislike?(@user, @post)
    # arr = @user.posts_disliked.select { |p| p == @post }
    # assert_equal arr.length, 1
    # assert_equal arr[0], @post
    assert_equal 1, @post.dislikes_count
    # arr = @user.posts_liked.select { |p| p == @post }
    # assert_equal arr.length, 0
    assert_equal 0, @post.likes_count
  end

  test "user likes a comment" do
    assert_not Like.like?(@user, @comment)
    Like.like(@user, @comment)
    assert Like.like?(@user, @comment)
  end

  test "user dislikes a comment" do
    assert_not Like.dislike?(@user, @comment)
    Like.dislike(@user, @comment)
    assert Like.dislike?(@user, @comment)
  end

  test "user likes a comment and then doesn't like it" do
    Like.like(@user, @comment)
    assert Like.like?(@user, @comment)
    assert_not Like.dislike?(@user, @comment)
    Like.dislike(@user, @comment)
    assert Like.dislike?(@user, @comment)
    assert_not Like.like?(@user, @comment)
  end

  test "user dislikes a comment and then like it" do
    Like.dislike(@user, @comment)
    assert Like.dislike?(@user, @comment)
    assert_not Like.like?(@user, @comment)
    Like.like(@user, @comment)
    assert Like.like?(@user, @comment)
    assert_not Like.dislike?(@user, @comment)
  end

  test "user likes a comment only one time" do
    assert 0, @comment.likes_count
    Like.like(@user, @comment)
    Like.like(@user, @comment)
    assert Like.like?(@user, @comment)
    assert_equal 1, @comment.likes_count
    assert_equal 0, @comment.dislikes_count

    Like.dislike(@user, @comment)
    Like.dislike(@user, @comment)
    assert Like.dislike?(@user, @comment)
    assert_equal 1, @comment.dislikes_count
    assert_equal 0, @comment.likes_count
  end

end
