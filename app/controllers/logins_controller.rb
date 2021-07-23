class LoginsController < ApplicationController
  def create_user(user_info)
    random_password = User.new_token
    user = User.create!(
      "#{@strategy}_id": user_info.id,
      name: user_info.name,
      email: user_info.email,
      password: random_password,
      password_confirmation: random_password,
      activated: true)
  end

  def login(user)
    log_in user
    redirect_to root_path
  end
end
