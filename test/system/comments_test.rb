require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  def setup
    @user = users(:bob)
    @post = posts(:with_comments)
    @comment = posts(:hola)
    # log_in_as(@user)
  end

  test "click on the accordion to see the form for creating a comment" do
    #Log in
    visit root_path
    click_on "Log in"
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password"
    click_button "Log in"
    assert_text 'Success'

    # Visit profile page
    visit user_path(@user)
    assert_text 'Make a comment here...'
    assert_button "Comment"
    fill_in "Write a comment...", with: "Hola"
    click_button "Comment"
    # get user_path(@user)
    # assert_selector "h1", text: "Comments"
  end
end
