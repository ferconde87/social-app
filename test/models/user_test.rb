require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", 
      password: "foobar", password_confirmation: "foobar")
    @fernando = users(:fernando)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[ user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique and case-insensitive" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
    
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
    
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated posts should be destroyed" do
    @user.save
    @user.posts.create!(content: "Lorem ipsum")
    assert_difference 'Post.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    pepe = users(:pepe)
    assert_not pepe.following?(@fernando)
    assert_not @fernando.followers?(pepe)
    pepe.follow(@fernando)
    assert pepe.following?(@fernando)
    assert @fernando.followers?(pepe)
    pepe.unfollow(@fernando)
    assert_not pepe.following?(@fernando)
    assert_not @fernando.followers?(pepe)
  end   
  
  test "feed should have the right posts" do
    lana = users(:lana)
    pepe = users(:pepe)
    # Posts from followed user
    lana.posts.each do |post_following|
      assert @fernando.feed.include?(post_following)
    end
    # Posts from self are not seeing in the feed!
    @fernando.posts.each do |post_self|
      assert_not @fernando.feed.include?(post_self)
    end
    # Posts from unfollowed user
    pepe.posts.each do |post_unfollowed|
      assert_not @fernando.feed.include?(post_unfollowed)
    end
  end

  test "activate_with_atttribute only update the right attribute" do
    @fernando.activate_with_atttribute(:google_id, "google_id_value")
    assert_equal @fernando[:google_id], "google_id_value"
  end

  test "activate_with_attribute set the user activated" do
    @fernando.activated = false
    assert_not @fernando.activated?
    @fernando.activate_with_atttribute(:google_id, "google_id_value")
    assert @fernando.activated?
  end

  test "when user alredy activated keeps user activated" do
    @fernando.activated = true
    assert @fernando.activated?
    @fernando.activate_with_atttribute(:google_id, "google_id_value")
    assert @fernando.activated?
  end

  test "activate_with_attribute raise error if attribute is wrong" do
    assert_raise ActiveModel::MissingAttributeError do
      @fernando.activate_with_atttribute(:pepe, "google_id_value")
    end
  end

  test "activate_with_attribute raise error if parameter value type is wrong" do
    assert_raise TypeError do
      @fernando.activate_with_atttribute(:google_id, ["wrong data type"])
    end
  end
end
