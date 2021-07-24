require 'omniauth-facebook'

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development?
    # facebook_app_id = Rails.application.credentials.development[:FACEBOOK_APP_ID]
    # facebook_app_secret = Rails.application.credentials.development[:FACEBOOK_APP_SECRET]
    # provider :facebook, facebook_app_id, facebook_app_secret,
    # scope: 'email', display: 'popup'
    facebook_app_id = Rails.application.credentials.development[:FACEBOOK_APP_ID]
    facebook_app_secret = Rails.application.credentials.development[:FACEBOOK_APP_SECRET]
    provider :facebook, facebook_app_id, facebook_app_secret
  else
    provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']
  end
end
