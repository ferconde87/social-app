class LikesController < ApplicationController
  before_action :logged_in_user
  before_action :current_content, only: [:like, :dislike]

  def like
    choice("like")
  end

  def dislike
    choice("dislike")
  end

  private
  
  def current_content
    content_class_name = params[:content].capitalize
    @content ||= content_class_name.constantize.find(params[:id])
    @object = @content
  end

  def choice(option = "like")
    respond_to do |format|

      if !Like.send("#{option}?", current_user, @content)
        Like.send("#{option}", current_user, @content)
      else
        Like.send("cancel_#{option}", current_user, @content)
      end
      format.html { redirect_back fallback_location: root_url }
      format.js { render option }
    end
  end
end
