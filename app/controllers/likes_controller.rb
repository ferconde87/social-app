class LikesController < ApplicationController
  before_action :logged_in_user
  before_action :current_content, only: [:like, :dislike]

  def like
    respond_to do |format|
      if !current_user.like? @content
        current_user.like @content
      else
        current_user.cancel_like @content
      end
      format.html { redirect_back fallback_location: root_url }
      format.js { render 'like'}
    end
  end

  def dislike
    respond_to do |format|
      if !current_user.dislike? @content
        current_user.dislike @content
      else
        current_user.cancel_dislike @content
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
