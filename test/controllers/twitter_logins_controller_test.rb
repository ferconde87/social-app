# require 'webmock/minitest'
# require 'test_helper'

# class LoginsControllerTest < ActionDispatch::IntegrationTest

#   def external_redirect(url)
#     yield
#   rescue ActionController::RoutingError # goes to twitter.com/oauth/authenticate
#     current_url.must_equal url
#   else
#     raise "Missing external redirect"
#   end

#   it "signs up" do
#     twitter_id = 12345
#     visit "/"
    
#     stub_request(:post, "https://api.twitter.com/oauth/request_token").
#       to_return(body: "oauth_token=TOKEN&oauth_token_secret=SECRET&oauth_callback_confirmed=true")

#     external_redirect "https://api.twitter.com/oauth/authenticate?x_auth_access_type=read&oauth_token=TOKEN" do
#       click_link "Continue with Twitter"
#     end

#     # https://dev.twitter.com/oauth/reference/post/oauth/access_token
#     stub_request(:post, "https://api.twitter.com/oauth/access_token").
#       to_return(body: "oauth_token=TOKEN&oauth_token_secret=SECRET&user_id=#{twitter_id}&screen_name=twitterapi")

#     # https://dev.twitter.com/rest/reference/get/account/verify_credentials
#     stub_request(:get, "https://api.twitter.com/1.1/account/verify_credentials.json?include_entities=false&skip_status=true").
#       to_return(body: %{{"profile_image_url_https": "image_normal.png"}})

#     visit "/auth/twitter/callback"
#   end
# end
