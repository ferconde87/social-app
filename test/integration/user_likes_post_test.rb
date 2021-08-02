require "test_helper"

class UserLikesPostTest < ActionDispatch::IntegrationTest
  def setup
    @fer = users(:fernando)
    @post = posts(:hola)
    @michael = users(:michael)
    @zone = posts(:zone)
    log_in_as(@fer)
  end

  test "user likes a post" do
    assert_not @fer.like?(@post)
    likes_before = @post.likes_count
    dislikes_before = @post.dislikes_count
    assert_difference 'Like.count', 1 do
      @fer.like_post @post
    end
    assert @fer.like?(@post)
    @post.reload
    assert_equal likes_before+1, @post.likes_count
    assert_equal dislikes_before, @post.dislikes_count
  end

  test "user likes a post with other likes then dislikes it" do
    assert_not @fer.like?(@zone)
    get user_path(@michael)
    assert_template 'users/show'
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 0
    assert_select 'i.bi.bi-hand-thumbs-up', count: 2
    assert_select 'i.bi.bi-hand-thumbs-up', text: "2"
    assert_difference '@fer.posts_liked.length', 1 do
      @fer.like_post @zone
    end
    assert @fer.like?(@zone)
    get user_path(@michael)
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-up-fill', text: "3"
    assert_select 'i.bi.bi-hand-thumbs-up', count: 1
    
    # TODO update Like instead of using post_liked & post_not_liked
    assert_not @fer.dislike? @zone
    assert_select 'i.bi.bi-hand-thumbs-down', count: 2
    assert_select 'i.bi.bi-hand-thumbs-down', text: "1"
    
    assert_no_difference 'Post.count' do
      @fer.dislike_post @zone
    end
    
    assert @fer.dislike? @zone
    get user_path(@michael)
    assert_select 'i.bi.bi-hand-thumbs-down-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-down-fill', text: "2"
    assert_select 'i.bi.bi-hand-thumbs-up', count: 2
    assert_select 'i.bi.bi-hand-thumbs-up', text: "2"
  end


end
