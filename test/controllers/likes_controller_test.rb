require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:fernando)
    @pepe_post1 = posts(:hola)
    @pepe_post2 = posts(:moni)
    @pepe = users(:pepe)
    log_in_as(@user)
  end

  test "like a post" do
    assert_not @user.like? @post
    assert_equal  @pepe.posts.length, 2
    get user_path(@pepe)
    assert_template 'users/show'
    assert_select 'i.bi.bi-hand-thumbs-up', count: 2
    assert_select 'i.bi.bi-hand-thumbs-up', text: "0"
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 0
    assert_select 'i.bi.bi-hand-thumbs-down', count: 2
    assert_select 'i.bi.bi-hand-thumbs-down-fill', count: 0
    assert_difference 'Like.count', 1 do
      post "/like_post/#{@pepe_post1.id}"
    end
    get user_path(@pepe)
    assert_template 'users/show'
    assert_select 'i.bi.bi-hand-thumbs-up', count: 1
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-up-fill', text: "1"
    assert_select 'i.bi.bi-hand-thumbs-down', count: 2
    assert_select 'i.bi.bi-hand-thumbs-down-fill', count: 0
    #pepe also like his post
    log_in_as(@pepe)
    assert_difference 'Like.count', 1 do
      post "/like_post/#{@pepe_post1.id}"
    end
    get user_path(@pepe)
    assert_select 'i.bi.bi-hand-thumbs-up-fill', text: "2"
  end

  test "dislike a post" do
    assert_not @user.dislike? @pepe_post2
    get user_path(@pepe)
    assert_select 'i.bi.bi-hand-thumbs-down', count: 2
    assert_select 'i.bi.bi-hand-thumbs-down-fill', count: 0
    assert_difference 'Like.count' do
      post "/dislike_post/#{@pepe_post1.id}"
    end
    get user_path(@pepe)
    assert_select 'i.bi.bi-hand-thumbs-down', count: 1
    assert_select 'i.bi.bi-hand-thumbs-down-fill', count: 1
  end

  test "cancel a like" do
    post "/like_post/#{@pepe_post1.id}"
    assert @user.like? @pepe_post1
    get user_path(@pepe)
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-up-fill', text: "1"
    assert_select 'i.bi.bi-hand-thumbs-up', count: 1
    
    assert_difference 'Like.count', -1 do
      post "/cancel_like/#{@pepe_post1.id}"
    end
    
    assert_not @user.like? @pepe_post1
    get user_path(@pepe)
    assert_select 'i.bi.bi-hand-thumbs-up-fill', count: 0
    assert_select 'i.bi.bi-hand-thumbs-up', count: 2
    assert_select 'i.bi.bi-hand-thumbs-up', text: "0"
    assert_select 'i.bi.bi-hand-thumbs-up', count: 2
  end

  test "cancel a dislike" do
    post "/dislike_post/#{@pepe_post1.id}"
    assert @user.dislike? @pepe_post1
    get user_path(@pepe)
    assert_select 'i.bi.bi-hand-thumbs-down-fill', count: 1
    assert_select 'i.bi.bi-hand-thumbs-down-fill', text: "1"
    assert_select 'i.bi.bi-hand-thumbs-down', count: 1
    
    assert_difference 'Like.count', -1 do
      post "/cancel_dislike/#{@pepe_post1.id}"
    end
    
    assert_not @user.dislike? @pepe_post1
    get user_path(@pepe)
    assert_select 'i.bi.bi-hand-thumbs-down-fill', count: 0
    assert_select 'i.bi.bi-hand-thumbs-down', count: 2
    assert_select 'i.bi.bi-hand-thumbs-down', text: "0"
    assert_select 'i.bi.bi-hand-thumbs-down', count: 2
  end
end
