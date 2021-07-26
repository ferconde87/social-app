class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    if @post.save
      flash[:success] = "New post created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = "Post deleted!"
      redirect_back(fallback_location: root_url)
    else
      flash[:info] = "Unable to delete the post"
      render 'static_pages/home'
    end
  end

  def update_likes
    debugger
     @like = @post.likes.build(curent_user)
     if like.save
      flash[:info] = "Post liked!"
     else
      flash[:danger] = "Your like could not be saved!"
     end
     redirect_back(fallback_location: root_url)
  end

  private

  def post_params
    params.require(:post).permit(:content, :image)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil? 
  end
end
