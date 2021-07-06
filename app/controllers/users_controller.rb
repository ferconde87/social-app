class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to Social!"
      redirect_to @user
    else
      render 'users/new'
    end
  end

  private

    def user
      @user ||= User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
