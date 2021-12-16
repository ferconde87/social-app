class TwitterLoginsController < LoginsController
  def new
  end
  
  def create
    create("twitter")
  end
  
  def cancelled
    #when the user denies the facebook login popup
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
