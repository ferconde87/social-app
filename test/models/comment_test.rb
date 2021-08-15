require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = users(:bob)
    @post = @user.posts.build(content: "Lorem ipsum")
    @comment = @user.comments.build(post: @post, content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @comment.valid?
  end
    
  test "user id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "content should be present" do
    @comment.content = ""
    assert_not @comment.valid?
  end

  test "content should be at most 1000 characters" do
    @comment.content = "a" * 1001
    assert_not @comment.valid?
  end

  test "order should be most recent first" do
    assert_equal comments(:now), Comment.first
  end  
end
