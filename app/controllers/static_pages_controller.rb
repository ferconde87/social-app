class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user
      @post = @user.posts.build
      @feed_items = @user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end
end
