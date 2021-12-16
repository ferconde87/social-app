class LoginsController < ApplicationController
  def login_message
    "Successfully logged in"
  end

  def signup_message
    "Your profile has been created successfully!"
  end

  def create(method)
    id = auth_hash.uid
    user = User.find_by("#{method}_id": id)
    email = auth_hash.info.email
    if user.nil? && !email.nil?
      if user = User.find_by(email: email)
        user.activate_with_atttribute("#{method}_id", id)
      end
    end
    if user.nil?
      user_info = {}
      user_info[:name] = auth_hash.info.name
      user_info[:email] = email.nil? ? "#{id}@#{method}.com"  : email
      user_info["#{method}_id".to_sym] = id
      user = create_user(user_info)
      login(user, signup_message)
    else
      login(user, login_message)
    end
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
