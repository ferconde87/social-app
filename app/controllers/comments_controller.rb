class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    current_user.comments.create(post_id: params[:post_id], content:  params[:comment][:content])
    redirect_back(fallback_location: root_url)
  end

  def destroy
    if !@comment.destroy
      flash[:info] = "Unable to delete the comment"
      render root_path
    end
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
