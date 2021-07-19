require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @post = posts(:orange)
  end
    
  test "should redirect create when not logged in" do
    assert_no_difference 'Post.count' do
      post posts_path, 
      params: {
        post: { content: "Lorem ipsum" } 
      }
    end
    assert_redirected_to login_url
  end
    
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong post" do
    log_in_as(users(:fernando))
    post = posts(:ants)
    assert_no_difference 'Post.count' do
      delete post_path(post)
    end
    assert_redirected_to root_url
  end

  test "should destroy the post when the user is the owner" do
    log_in_as(users(:fernando))
    post = posts(:orange)
    assert_difference 'Post.count', -1 do
      delete post_path(post)
    end
    assert_not flash.empty?
    follow_redirect!
    assert_select 'div.alert.alert-success'
  end
end
