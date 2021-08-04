class LikesController < ApplicationController
  before_action :logged_in_user
  before_action :current_post

  def like
    respond_to do |format|
      if !current_user.like? @post
        current_user.like_post @post
      else
        current_user.cancel_like @post
      end
      format.html { redirect_back fallback_location: root_url }
      format.js
    end
  end

  def dislike
    respond_to do |format|
      if !current_user.dislike? @post
        current_user.dislike_post @post
      else
        current_user.cancel_dislike @post
      end
      format.html { redirect_back fallback_location: root_url }
      format.js
    end
  end

  def current_post
    @post ||= Post.find(params[:id])
  end
end
