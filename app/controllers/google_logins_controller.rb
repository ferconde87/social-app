class GoogleLoginsController < ApplicationController
  def new
  end

  def create
    if google_user = authenticate_with_google
      user = User.find_by(email: google_user.email_address)
      if user.nil?
        name = google_user.name
        email = google_user.email_address
        @user = User.new(name: name, email: email, activated: true)
        render :template => "users/new"
        # redirect_to new_user_path(user: {name: name, email: email})
        return
      end
      # cookies.signed[:user_id] = user.id
      log_in user
      redirect_to user
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
