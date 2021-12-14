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
    
    @lana = users(:lana)
    Like.like(@lana, @zone)
    Like.dislike(@michael, @zone)
    @malory = users(:malory)
    Like.like(@malory, @zone)
  end

  test "user likes a post" do
    assert_not Like.like?(@fer, @post)
    likes_before = @post.likes_count
    dislikes_before = @post.dislikes_count
    assert_difference 'Like.count', 1 do
      Like.like(@fer, @post)
    end
    assert Like.like?(@fer, @post)
    @post.reload
    assert_equal likes_before+1, @post.likes_count
    assert_equal dislikes_before, @post.dislikes_count
  end

  test "user likes a post with other likes then dislikes it" do
    assert_not Like.like?(@fer, @zone)
    get user_path(@michael)
    assert_template 'users/show'
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 0
    assert_select 'i.bi.bi-hand-thumbs-up', count: 2
    # assert_select 'i.bi.bi-hand-thumbs-up', text: "2"
    assert_difference '@fer.likes.length', 1 do
      Like.like(@fer, @zone)
    end
    assert Like.like?(@fer, @zone)
    get user_path(@michael)
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 1
    # assert_select 'i.bi.bi-hand-thumbs-up-fill', text: "3"
    # assert_select 'i.bi.bi-hand-thumbs-up', count: 1
    
    # TODO update Like instead of using post_liked & post_not_liked
    assert_not Like.dislike?(@fer, @zone)
    assert_select 'i.bi.bi-hand-thumbs-down', count: 2
    assert_select 'i.bi.bi-hand-thumbs-down', text: "1"
    
    assert_no_difference 'Post.count' do
      Like.dislike(@fer, @zone)
    end
    
    assert Like.dislike?(@fer, @zone)
    get user_path(@michael)
    assert_select 'i.bi.bi-hand-thumbs-down-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-down-fill', text: "2"
    assert_select 'i.bi.bi-hand-thumbs-up', count: 2
    assert_select 'i.bi.bi-hand-thumbs-up', text: "2"
  end

  test "show the right links" do
    assert_not Like.like?(@fer, @unique)
    get user_path(@homero)
    assert_select "a[href=?]", "/like/post/#{@unique.id}"
    assert_select "a[href=?]", "/dislike/post/#{@unique.id}"
    Like.like(@fer, @unique)
    get user_path(@homero)
    assert_select "a[href=?]", "/like/post/#{@unique.id}"
    Like.dislike(@fer, @unique)
    get user_path(@homero)
    assert_select "a[href=?]", "/dislike/post/#{@unique.id}"
  end

  test "number of likes and dislikes" do
    #like
    assert_not Like.like?(@fer, @unique)
    assert_equal 0, @unique.likes_counter
    Like.like(@fer, @unique)
    assert_equal 1, @unique.likes_counter
    assert_not Like.like?(@homero, @unique)
    Like.like(@homero, @unique)
    assert_equal 2, @unique.likes_counter
    #dislike
    assert_equal 0, @unique.dislikes_counter
    Like.dislike(@homero, @unique)
    assert_equal 1, @unique.dislikes_counter
    assert_equal 1, @unique.likes_counter
    Like.dislike(@fer, @unique)
    assert_equal 2, @unique.dislikes_counter
    assert_equal 0, @unique.likes_counter
    #cancel_dislike
    Like.cancel_dislike(@fer, @unique)
    assert_equal 1, @unique.dislikes_counter
    Like.cancel_dislike(@homero, @unique)
    assert_equal 0, @unique.dislikes_counter
    #cancel_like
    Like.like(@fer, @unique)
    Like.like(@homero, @unique)
    assert_equal 2, @unique.likes_counter
    Like.cancel_like(@fer, @unique)
    assert_equal 1, @unique.likes_counter
    Like.cancel_like(@homero, @unique)
    assert_equal 0, @unique.likes_counter
  end
end
