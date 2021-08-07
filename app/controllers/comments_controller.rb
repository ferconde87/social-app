class CommentsController < ApplicationController
  def create
    current_user.comments.create(post_id: params[:post_id], content:  params[:comment][:content])
    redirect_back(fallback_location: root_url)
  end

  def destroy
  end
end
