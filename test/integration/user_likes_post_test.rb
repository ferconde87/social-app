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
    @lana.like @zone
    @michael.dislike @zone
    @malory = users(:malory)
    @malory.like @zone
  end

  test "user likes a post" do
    assert_not @fer.like?(@post)
    likes_before = @post.likes_count
    dislikes_before = @post.dislikes_count
    assert_difference 'Like.count', 1 do
      @fer.like @post
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
    # assert_select 'i.bi.bi-hand-thumbs-up', text: "2"
    assert_difference '@fer.likes.length', 1 do
      @fer.like @zone
    end
    assert @fer.like?(@zone)
    get user_path(@michael)
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 1
    # assert_select 'i.bi.bi-hand-thumbs-up-fill', text: "3"
    # assert_select 'i.bi.bi-hand-thumbs-up', count: 1
    
    # TODO update Like instead of using post_liked & post_not_liked
    assert_not @fer.dislike? @zone
    assert_select 'i.bi.bi-hand-thumbs-down', count: 2
    assert_select 'i.bi.bi-hand-thumbs-down', text: "1"
    
    assert_no_difference 'Post.count' do
      @fer.dislike @zone
    end
    
    assert @fer.dislike? @zone
    get user_path(@michael)
    assert_select 'i.bi.bi-hand-thumbs-down-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-down-fill', text: "2"
    assert_select 'i.bi.bi-hand-thumbs-up', count: 2
    assert_select 'i.bi.bi-hand-thumbs-up', text: "2"
  end

  test "show the right links" do
    assert_not @fer.like?(@unique)
    get user_path(@homero)
    assert_select "a[href=?]", "/like/post/#{@unique.id}"
    assert_select "a[href=?]", "/dislike/post/#{@unique.id}"
    @fer.like @unique
    get user_path(@homero)
    assert_select "a[href=?]", "/like/post/#{@unique.id}"
    @fer.dislike @unique
    get user_path(@homero)
    assert_select "a[href=?]", "/dislike/post/#{@unique.id}"
  end

  test "number of likes and dislikes" do
    #like
    assert_not @fer.like?(@unique)
    assert_equal 0, @unique.likes_counter
    @fer.like @unique
    assert_equal 1, @unique.likes_counter
    assert_not @homero.like?(@unique)
    @homero.like @unique
    assert_equal 2, @unique.likes_counter
    #dislike
    assert_equal 0, @unique.dislikes_counter
    @homero.dislike @unique
    assert_equal 1, @unique.dislikes_counter
    assert_equal 1, @unique.likes_counter
    @fer.dislike @unique
    assert_equal 2, @unique.dislikes_counter
    assert_equal 0, @unique.likes_counter
    #cancel_dislike
    @fer.cancel_dislike @unique
    assert_equal 1, @unique.dislikes_counter
    @homero.cancel_dislike @unique
    assert_equal 0, @unique.dislikes_counter
    #cancel_like
    @fer.like @unique
    @homero.like @unique
    assert_equal 2, @unique.likes_counter
    @fer.cancel_like @unique
    assert_equal 1, @unique.likes_counter
    @homero.cancel_like @unique
    assert_equal 0, @unique.likes_counter
  end
end
