require "test_helper"

class UserLikesPostTest < ActionDispatch::IntegrationTest
  def setup
    @fer = users(:fernando)
    @post = posts(:hola)
    @michael = users(:michael)
    @zone = posts(:zone)
    @homero = users(:homero)
    @unique = posts(:unique)
    log_in_as(@fer)
  end

  test "user likes a post" do
    assert_not @fer.like_post?(@post)
    likes_before = @post.likes_count
    dislikes_before = @post.dislikes_count
    assert_difference 'Like.count', 1 do
      @fer.like_post @post
    end
    assert @fer.like_post?(@post)
    @post.reload
    assert_equal likes_before+1, @post.likes_count
    assert_equal dislikes_before, @post.dislikes_count
  end

  test "user likes a post with other likes then dislikes it" do
    assert_not @fer.like_post?(@zone)
    get user_path(@michael)
    assert_template 'users/show'
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 0
    assert_select 'i.bi.bi-hand-thumbs-up', count: 2
    assert_select 'i.bi.bi-hand-thumbs-up', text: "2"
    assert_difference '@fer.posts_liked.length', 1 do
      @fer.like_post @zone
    end
    assert @fer.like_post?(@zone)
    get user_path(@michael)
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-up-fill', text: "3"
    assert_select 'i.bi.bi-hand-thumbs-up', count: 1
    
    # TODO update Like instead of using post_liked & post_not_liked
    assert_not @fer.dislike_post? @zone
    assert_select 'i.bi.bi-hand-thumbs-down', count: 2
    assert_select 'i.bi.bi-hand-thumbs-down', text: "1"
    
    assert_no_difference 'Post.count' do
      @fer.dislike_post @zone
    end
    
    assert @fer.dislike_post? @zone
    get user_path(@michael)
    assert_select 'i.bi.bi-hand-thumbs-down-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-down-fill', text: "2"
    assert_select 'i.bi.bi-hand-thumbs-up', count: 2
    assert_select 'i.bi.bi-hand-thumbs-up', text: "2"
  end

  test "show the right links" do
    assert_not @fer.like_post?(@unique)
    get user_path(@homero)
    assert_select "a[href=?]", "/like_post/#{@unique.id}"
    assert_select "a[href=?]", "/dislike_post/#{@unique.id}"
    @fer.like_post @unique
    get user_path(@homero)
    assert_select "a[href=?]", "/like_post/#{@unique.id}"
    @fer.dislike_post @unique
    get user_path(@homero)
    assert_select "a[href=?]", "/dislike_post/#{@unique.id}"
  end
end
