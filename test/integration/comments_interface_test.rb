require "test_helper"

class CommentsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
    @post = posts(:with_comments)
    @comment = posts(:hola)
  end
    
  test "post interface" do
    log_in_as(@user)
    get user_path(@user)
    assert_match 'Make a comment here...', response.body
    assert_select 'input[type=submit]', value: 'Comment'

    # Invalid submission
    assert_no_difference 'Comment.count' do
      post comments_path, params: { comment: { content: "" } }
    end
    
    # Valid submission
    content = "This comment really ties the room together"
    assert_difference 'Comment.count', 1 do
      post comments_path, 
      params: { 
        comment: { 
          content: content
        },
        post_id: @post.id
      }
    end
      assert_redirected_to root_url
      get user_path(@post.user)
      assert_match content, response.body

    comment = @user.comments.first
    # Delete comment
    assert_match 'data-method="delete"', response.body
    assert_difference 'Comment.count', -1 do
      delete comment_path(comment)
    end
    
    # Visit different user (no delete links)

    get user_path(@user)
    #a[data-method] => 1 logout + 3 (like/dislike/delete post) + 3*3 (like/dislike/delete comment)
    assert_select 'a[data-method]', count: 13  
    
    log_in_as(users(:fernando))
    get user_path(@user)
    assert_select 'a[data-method]', count: 9 # 1 logout + (2 like/dislike * (1 post + 3 comments))
  end
end
