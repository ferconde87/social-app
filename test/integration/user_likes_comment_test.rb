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
    assert_not @fer.like?(@comment1)
    likes_before = @comment1.likes_count
    dislikes_before = @comment1.dislikes_count
    assert_difference 'Like.count', 1 do
      @fer.like @comment1
    end
    assert @fer.like?(@comment1)
    @comment1.reload
    assert_equal likes_before+1, @comment1.likes_count
    assert_equal dislikes_before, @comment1.dislikes_count
  end

  test "user likes a comment with other likes then dislikes it" do
    assert_not @bob.like? @comment2
    @bob.like @comment2
    assert_not @fer.like?(@comment2)
    get user_path(@bob)
    assert_template 'users/show'
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 0
    assert_select 'i.bi.bi-hand-thumbs-up', count: 4 #1 post + 3 comments
    assert_select 'i.bi.bi-hand-thumbs-up', text: "1"
    assert_difference '@fer.comments_liked.length', 1 do
      @fer.like @comment2
    end
    assert @fer.like? @comment2
    get user_path(@bob)
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-up-fill', text: "2"
    assert_select 'i.bi.bi-hand-thumbs-up', count: 3
    
    # TODO update Like instead of using post_liked & post_not_liked
    assert_not @fer.dislike? @comment2
    assert_select 'i.bi.bi-hand-thumbs-down', count: 4
    assert_select 'i.bi.bi-hand-thumbs-down', text: "0"
    
    assert_no_difference 'Comment.count' do
      @fer.dislike @comment2
    end
    
    assert @fer.dislike? @comment2
    get user_path(@bob)
    assert_select 'i.bi.bi-hand-thumbs-down-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-down-fill', text: "1"
    assert_select 'i.bi.bi-hand-thumbs-up', count: 4
    assert_select 'i.bi.bi-hand-thumbs-up', text: "1"
  end

  test "show the right links" do
    assert_not @fer.like?(@comment3)
    get user_path(@bob)
    assert_select "a[href=?]", "/like/comment/#{@comment3.id}"
    assert_select "a[href=?]", "/dislike/comment/#{@comment3.id}"
    @fer.like @comment3
    get user_path(@bob)
    assert_select "a[href=?]", "/like/comment/#{@comment3.id}"
    @fer.dislike @comment3
    get user_path(@bob)
    assert_select "a[href=?]", "/dislike/comment/#{@comment3.id}"
  end
end
