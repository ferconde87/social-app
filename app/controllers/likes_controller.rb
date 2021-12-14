class LikesController < ApplicationController
  before_action :logged_in_user
  before_action :current_content, only: [:like, :dislike]

  def like
    respond_to do |format|
      if !Like.like?(current_user, @content)
        Like.like(current_user, @content)
      else
        Like.cancel_like(current_user, @content)
      end
      format.html { redirect_back fallback_location: root_url }
      format.js { render 'like'}
    end
  end

  def dislike
    respond_to do |format|
      if !Like.dislike?(current_user, @content)
        Like.dislike(current_user, @content)
      else
        Like.cancel_dislike(current_user, @content)
      end
      format.html { redirect_back fallback_location: root_url }
      format.js { render 'dislike' }
    end
  end

  private
  
  def current_content
    content_class_name = params[:content].capitalize
    @content ||= content_class_name.constantize.find(params[:id])
    @object = @content
  end
end
