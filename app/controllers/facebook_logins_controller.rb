class FacebookLoginsController < LoginsController
  def new
  end
  
  def create
    create("facebook")
  end
  
  def cancelled
    #when the user denies the facebook login popup
    debugger
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
