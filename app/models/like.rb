class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, optional: true  
  belongs_to :comment, optional: true

  def self.like?(user, content)
    !user.likes.find {|like| like.send("#{content.class.model_name.singular}_id") == content.id && like.liked == true}.nil?
  end

  def self.dislike?(user, content)
    !user.likes.find {|like| like.send("#{content.class.model_name.singular}_id") == content.id && like.liked == false }.nil?
  end

  def self.cancel_like(user, content)
    return if !Like.like?(user, content)
    user.likes.find_by("#{content.class.model_name.singular}_id": content.id, liked: true).destroy
    content.likes_counter -= 1
    content.save
    user.likes.reload
  end

  def self.cancel_dislike(user, content)
    return if !Like.dislike?(user, content)
    user.likes.find_by("#{content.class.model_name.singular}_id": content.id, liked: false).destroy
    content.dislikes_counter -= 1
    content.save
    user.likes.reload
  end

  def self.like(user, content)
    Like.cancel_dislike(user, content)
    return if Like.like?(user, content)
    user.likes.create!("#{content.class.model_name.singular}_id": content.id, liked: true)
    content.likes_counter += 1
    content.save
    user.likes.reload
  end

  def self.dislike(user, content)
    Like.cancel_like(user, content)
    return if Like.dislike?(user, content)
    user.likes.create!("#{content.class.model_name.singular}_id": content.id, liked: false)
    content.dislikes_counter += 1
    content.save
    user.likes.reload
  end
end
