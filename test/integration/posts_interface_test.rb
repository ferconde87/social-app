require "test_helper"

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:fernando)
    @lana = users(:lana)
  end
    
  test "post interface" do
    log_in_as(@lana)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    
    # Invalid submission
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "" } }
    end
    assert_select 'div.alert.alert-danger'
    assert_select 'div.pagination'
    
    log_in_as(@user)
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
    # follow_redirect!
    log_in_as(@lana)#change the user to check lana can see fernando's post
    get root_path
    assert_match content, response.body#cool!
    log_in_as(@user)#coming back to fernando
    
    # Delete post
    get user_path(users(:fernando))#need to go to the user's profile
    #1 a[data-method] logout + 30 from posts * 3 (delete + like + dislike) = 91 
    assert_select 'a[data-method]', count: 91 
    assert_match 'data-method="delete"', response.body
    first_post = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    
    # Visit different user (no delete links)
    get user_path(users(:michael))
    assert_match 'Posts (2)', response.body
    assert_select 'a[data-method]', count: 5 #logout + 2*like + 2*dislike
  end

  test "post count" do
    log_in_as(@user)
    get user_path(@user)
    assert_match "#{@user.posts.count} posts", response.body
    # get root_path
    
    # User with zero microposts
    other_user = users(:michael)
    log_in_as(other_user)
    # get root_path
    get user_path(other_user)
    assert_match "2 posts", response.body
    other_user.posts.create!(content: "A post")
    get root_path
    assert_no_match "A post", response.body
    get user_path(users(:michael))#go to profile
    assert_match "A post", response.body
    assert_match "Posts (3)", response.body#profile
  end     
end
