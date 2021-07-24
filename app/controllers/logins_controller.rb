class LoginsController < ApplicationController
  def login_message
    "Successfully logged in"
  end

  def signup_message
    "Your profile has been created successfully!"
  end

  def create_user(user_info)
    user_info[:password] = User.new_token
    user_info[:password_confirmation] = user_info[:password]
    user_info[:activated] = true
    user_info[:activated_at] = Time.zone.now
    user = User.create(user_info)
    user
  end

  def login(user, message)
    flash[:success] = message
    log_in user
    redirect_to root_url
  end


  # TODO: show this two message when signup
  def signup(user, message)
    flash[:success] = [login_message]
    flash[:success] << signup_message
    login(user, message)
  end
end
