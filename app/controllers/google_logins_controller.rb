class GoogleLoginsController < LoginsController
  def new
  end

  def create
    if google_user = authenticate_with_google
      id = google_user.user_id
      user = User.find_by(google_id: id)
      if user.nil?
        if user = User.find_by(email: google_user.email_address)
          user.activate_with_atttribute("google_id", id)
        end
      end
      if user.nil?
        user_info = {}
        user_info[:name] = google_user.name
        user_info[:email] = google_user.email_address
        user_info[:google_id] = id
        user = create_user(user_info)
        login(user, signup_message)
      else
        login(user, login_message)
      end
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
