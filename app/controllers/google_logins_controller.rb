class GoogleLoginsController < ApplicationController
  def new
  end

  def create
    if google_user = authenticate_with_google
      user = User.find_by(email: google_user.email_address)
      if user.nil?
        random_password = User.new_token
        user = User.create!(
          name: google_user.name,
          email: google_user.email_address,
          password: random_password,
          password_confirmation: random_password,
          activated: true)

        flash[:success] = "Your profile has been created successfully!"
      else
        flash[:success] = 'Successfully logged in'
      end
      log_in user
      redirect_to root_path
    else
      redirect_to login_url, alert: 'Google authentication fail'
    end
  end

  private
    def authenticate_with_google
      if id_token = flash[:google_sign_in]["id_token"]
        flash.delete(:google_sign_in)
        GoogleSignIn::Identity.new(id_token)
      elsif error = flash[:google_sign_in][:error]
        logger.error "Google authentication error: #{error}"
        nil
      end
    end
end
