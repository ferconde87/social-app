class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end
  
  def show
    # redirect_to root_url and return unless user.activated?
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
  end
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url      
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    # @user = User.find(params[:id])
    if @user.update(user_params)
      #successful upate
      flash[:success] = "Your profile has been updated successfully!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user_deleted = User.find(params[:id]).destroy
    flash[:success] = "#{user_deleted.name} with user id #{user_deleted.id} deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
    
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
    
  private
    def user
      @user ||= User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
