class LikesController < ApplicationController
  before_action :logged_in_user
  before_action :current_post

  def like
    current_user.like_post @post
    redirect_back(fallback_location: root_url)
  end

  def cancel_like
    current_user.cancel_like @post
    redirect_back(fallback_location: root_url)
  end

  def dislike
    current_user.dislike_post @post
    redirect_back(fallback_location: root_url)
  end

  def cancel_dislike
    current_user.cancel_dislike @post
    redirect_back(fallback_location: root_url)
  end

  def current_post
    @post = Post.find(params[:id])
  end
end
