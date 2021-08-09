class TwitterLoginsController < LoginsController
  def new
  end
  
  def create
    id = auth_hash.uid
    user = User.find_by(twitter_id: id)
    email = auth_hash.info.email
    if user.nil? && !email.nil?
      if user = User.find_by(email: email)
        debugger
        user.activate_with_atttribute("twitter_id", id)
      end
    end
    if user.nil?
      user_info = {}
      user_info[:name] = auth_hash.info.name
      user_info[:email] = email.nil? ? "#{id}@fb.com"  : email
      user_info[:twitter_id] = id
      user = create_user(user_info)
      login(user, signup_message)
    else
      login(user, login_message)
    end
  end
  
  def cancelled
    #when the user denies the facebook login popup
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
