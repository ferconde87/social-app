class RelationshipsController < ApplicationController
  before_action :logged_in_user
  
  def create
    followed_user = User.find(params[:followed_id])
    Relationship.follow(current_user, followed_user)
    redirect_to followed_user
  end
  
  def destroy
    follower_user = Relationship.find(params[:id]).followed
    Relationship.unfollow(current_user, follower_user)
    redirect_to follower_user
  end
end
