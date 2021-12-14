require "test_helper"

class UserLikesCommentTest < ActionDispatch::IntegrationTest
  def setup
    @fer = users(:fernando)
    @bob = users(:bob)
    @comment1 = comments(:hola)
    @comment2 = comments(:now)
    @comment3 = comments(:chau)
    log_in_as(@fer)
  end

  test "user likes a post" do
    assert_not Like.like?(@fer, @comment1)
    likes_before = @comment1.likes_count
    dislikes_before = @comment1.dislikes_count
    assert_difference 'Like.count', 1 do
      Like.like(@fer, @comment1)
    end
    assert Like.like?(@fer, @comment1)
    @comment1.reload
    assert_equal likes_before+1, @comment1.likes_count
    assert_equal dislikes_before, @comment1.dislikes_count
  end

  test "user likes a comment with other likes then dislikes it" do
    assert_not Like.like?(@bob, @comment2)
    Like.like(@bob, @comment2)
    assert_not Like.like?(@fer, @comment2)
    get user_path(@bob)
    assert_template 'users/show'
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 0
    assert_select 'i.bi.bi-hand-thumbs-up', count: 4 #1 post + 3 comments
    assert_select 'i.bi.bi-hand-thumbs-up', text: "1"
    assert_difference '@fer.likes.length', 1 do
      Like.like(@fer, @comment2)
    end
    assert Like.like?(@fer, @comment2)
    get user_path(@bob)
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-up-fill', text: "2"
    assert_select 'i.bi.bi-hand-thumbs-up', count: 3
    
    # TODO update Like instead of using post_liked & post_not_liked
    assert_not Like.dislike?(@fer, @comment2)
    assert_select 'i.bi.bi-hand-thumbs-down', count: 4
    assert_select 'i.bi.bi-hand-thumbs-down', text: "0"
    
    assert_no_difference 'Comment.count' do
      Like.dislike(@fer, @comment2)
    end
    
    assert Like.dislike?(@fer, @comment2)
    get user_path(@bob)
    assert_select 'i.bi.bi-hand-thumbs-down-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-down-fill', text: "1"
    assert_select 'i.bi.bi-hand-thumbs-up', count: 4
    assert_select 'i.bi.bi-hand-thumbs-up', text: "1"
  end

  test "show the right links" do
    assert_not Like.like?(@fer, @comment3)
    get user_path(@bob)
    assert_select "a[href=?]", "/like/comment/#{@comment3.id}"
    assert_select "a[href=?]", "/dislike/comment/#{@comment3.id}"
    Like.like(@fer, @comment3)
    get user_path(@bob)
    assert_select "a[href=?]", "/like/comment/#{@comment3.id}"
    Like.dislike(@fer, @comment3)
    get user_path(@bob)
    assert_select "a[href=?]", "/dislike/comment/#{@comment3.id}"
  end

  test "user likes his/her own comment and then they delete the comment" do
    assert_not Like.like?(@bob, @comment1)
    assert_difference '@bob.likes.count', 1 do
      Like.like(@bob, @comment1)
    end
    assert Like.like?(@bob, @comment1)
    assert_difference '@bob.likes.count', -1 do
      @comment1.destroy
    end
    assert Like.like?(@bob, @comment1)
  end
end
