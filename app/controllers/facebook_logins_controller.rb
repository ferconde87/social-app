class FacebookLoginsController < LoginsController
  def initialize
    @strategy = "facebook"
  end

  def new
  end
  
  def create
    id = auth_hash.uid.to_i
    user = User.find_by(facebook_id: id)
    if user.nil?
      user_info = auth_hash.info
      user_info.id = id
      user_info.email = "#{user_info.id}@fb.com" if user_info.email.nil? 
      user = create_user(user_info)
      flash[:success] = "Your profile has been created successfully!"
    else
      flash[:success] = 'Successfully logged in'
    end
    login user
  end
  

  def cancelled
    #when the user denies the facebook login popup
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end   

end
