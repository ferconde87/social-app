require 'webmock/minitest'
require 'test_helper'

class LoginsControllerTest < ActionDispatch::IntegrationTest
  test "should login the user" do
    # stub_request(:post, "https://api.twitter.com/oauth/request_token")
    # stub_request(:post, "https://api.twitter.com/oauth/authenticate")
    # stub_request(:get, "https://api.twitter.com/1.1/account/verify_credentials.json?include_entities=false&skip_status=true").
    #   to_return(body: %{{"profile_image_url_https":< "image_normal.png"}})

    # post "//auth/twitter/", params: {"a": "b"}
    # assert_match "something", response.body

    #TODO test controller mocking requests / auth_hash (request.env['omniauth.auth'])  
    # with rspec mock or webmock 
  end        
end
        