require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
    @post = posts(:with_comments)
    @comment = comments(:chau)
  end
    
  test "should redirect create when not logged in" do
    assert_no_difference 'Comment.count' do
      post comments_path, 
      params: {
        post: { 
          user: @user,
          post: @post,
          content: "Lorem ipsum" 
        } 
      }
    end
    assert_redirected_to login_url
  end
    
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Comment.count' do
      delete comment_path(@comment)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when trying to delete a comment from other user" do
    log_in_as(users(:fernando))
    assert_no_difference 'Comment.count' do
      delete comment_path(@comment)
    end
    assert_redirected_to root_url
  end

  test "should destroy the comment when the user is the owner" do
    log_in_as(users(:bob))
    assert_difference 'Comment.count', -1 do
      delete comment_path(@comment)
    end
    assert_response :redirect
  end
end
