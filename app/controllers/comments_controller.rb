class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    respond_to do |format|
      @comment = current_user.comments.create(post_id: params[:post_id], content:  params[:comment][:content].squish)
      format.html { redirect_back fallback_location: root_url }
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        format.html { redirect_back fallback_location: root_url }
        format.js { render 'destroy'}
      else
        flash[:info] = "Unable to delete the comment"
        render root_path
      end
    end
    
    # respond_to do |format|  
    #   @comment.destroy
    #   format.html { redirect_back fallback_location: root_url }
    #   format.js
    # end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_url if @comment.nil?
  end
end
