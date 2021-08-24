require "test_helper"

class LikeTest < ActiveSupport::TestCase
  def setup 
    @user = users(:fernando)
    @post = posts(:hola)
    @bob = users(:bob)
    @comment = comments(:hola)
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
    assert 0, @post.likes_count
    @user.like @post
    @user.like @post
    assert @user.like? @post
    # arr = @user.posts_liked.select{ |p| p == @post }
    # assert_equal arr.length, 1
    # assert_equal arr[0], @post
    # arr = @user.posts_disliked.select { |p| p == @post }
    # assert_equal arr.length, 0
    assert_equal 1, @post.likes_count
    assert_equal 0, @post.dislikes_count

    @user.dislike @post
    @user.dislike @post
    assert @user.dislike? @post
    # arr = @user.posts_disliked.select { |p| p == @post }
    # assert_equal arr.length, 1
    # assert_equal arr[0], @post
    assert_equal 1, @post.dislikes_count
    # arr = @user.posts_liked.select { |p| p == @post }
    # assert_equal arr.length, 0
    assert_equal 0, @post.likes_count
  end

  test "user likes a comment" do
    assert_not @user.like? @comment
    @user.like @comment
    assert @user.like? @comment
  end

  test "user dislikes a comment" do
    assert_not @user.dislike? @comment
    @user.dislike @comment
    assert @user.dislike? @comment
  end

  test "user likes a comment and then doesn't like it" do
    @user.like @comment
    assert @user.like? @comment
    assert_not @user.dislike? @comment
    @user.dislike @comment
    assert @user.dislike? @comment
    assert_not @user.like? @comment
  end

  test "user dislikes a comment and then like it" do
    @user.dislike @comment
    assert @user.dislike? @comment
    assert_not @user.like? @comment
    @user.like @comment
    assert @user.like? @comment
    assert_not @user.dislike? @comment
  end

  test "user likes a comment only one time" do
    assert 0, @comment.likes_count
    @user.like @comment
    @user.like @comment
    assert @user.like? @comment
    assert_equal 1, @comment.likes_count
    assert_equal 0, @comment.dislikes_count

    @user.dislike @comment
    @user.dislike @comment
    assert @user.dislike? @comment
    assert_equal 1, @comment.dislikes_count
    assert_equal 0, @comment.likes_count
  end

end
