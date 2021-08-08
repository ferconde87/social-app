class LikesController < ApplicationController
  before_action :logged_in_user
  before_action :current_post, only: [:like_post, :dislike_post]
  before_action :current_comment, only: [:like_comment, :dislike_comment]

  def like_post
    respond_to do |format|
      if !current_user.like_post? @post
        current_user.like_post @post
      else
        current_user.cancel_like_post @post
      end
      format.html { redirect_back fallback_location: root_url }
      format.js { render 'like'}
    end
  end

  def dislike_post
    respond_to do |format|
      if !current_user.dislike_post? @post
        current_user.dislike_post @post
      else
        current_user.cancel_dislike_post @post
      end
      format.html { redirect_back fallback_location: root_url }
      format.js { render 'dislike' }
    end
  end

  def like_comment
    respond_to do |format|
      if !current_user.like_comment? @comment
        current_user.like_comment @comment
      else
        current_user.cancel_like_comment @comment
      end
      format.html { redirect_back fallback_location: root_url }
      format.js { render 'like'}
    end
  end

  def dislike_comment
    respond_to do |format|
      if !current_user.dislike_comment? @comment
        current_user.dislike_comment @comment
      else
        current_user.cancel_dislike_comment @comment
      end
      format.html { redirect_back fallback_location: root_url }
      format.js { render 'dislike' }
    end
  end

  private
  
  def current_post
    @post ||= Post.find(params[:id])
    @object = @post
  end

  def current_comment
    @comment ||= Comment.find(params[:id])
    @object = @comment
  end
end
