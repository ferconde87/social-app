require "test_helper"

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:fernando)
  end
    
  test "post interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    
    # Invalid submission
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "" } }
    end
    assert_select 'div.alert.alert-danger'
    assert_select 'div.pagination'
    
    # Valid submission
    content = "This post really ties the room together"
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    assert_difference 'Post.count', 1 do
      post posts_path, 
      params: { 
        post: { 
          content: content,
          image: image 
        } 
      }
    end
    assert @user.posts.first.image.attached?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    
    # Delete post
    assert_select 'a[data-method]', count: 31 #1 logout + 30 from posts
    assert_match 'data-method="delete"', response.body
    first_post = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    
    # Visit different user (no delete links)
    get user_path(users(:michael))
    assert_select 'a[data-method]', count: 1 #only logout
  end

  test "post count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.posts.count} posts", response.body
    
    # User with zero microposts
    other_user = users(:michael)
    log_in_as(other_user)
    get root_path
    assert_match "2 posts", response.body
    other_user.posts.create!(content: "A post")
    get root_path
    assert_match "A post", response.body
    assert_match "3 posts", response.body
  end     
end
