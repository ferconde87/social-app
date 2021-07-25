require 'omniauth-facebook'

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development?
    # provider :facebook, facebook_app_id, facebook_app_secret,
    # scope: 'email', display: 'popup'
    facebook_app_id = Rails.application.credentials.development[:FACEBOOK_APP_ID]
    facebook_app_secret = Rails.application.credentials.development[:FACEBOOK_APP_SECRET]
    provider :facebook, facebook_app_id, facebook_app_secret
    twitter_app_id = Rails.application.credentials.development[:TWITTER_APP_ID]
    twitter_app_secret = Rails.application.credentials.development[:TWITTER_APP_SECRET]
    provider :twitter, twitter_app_id, twitter_app_secret, origin_param: false
  else
    provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']
    provider :twitter, ENV['TWITTER_APP_ID'], ENV['TWITTER_APP_SECRET']
  end
end
