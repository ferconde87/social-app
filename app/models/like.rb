class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, optional: true  
  belongs_to :comment, optional: true

  def self.like?(user, content)
    !find(user, content).nil?
  end

  def self.dislike?(user, content)
    !find(user, content, false).nil?
  end

  def self.cancel_like(user, content)
    cancel(user, content)
  end

  def self.cancel_dislike(user, content)
    cancel(user, content, "dislike", false)
  end

  def self.like(user, content)
    choice(user, content)
  end

  def self.dislike(user, content)
    choice(user, content, "dislike", false)
  end

  private

  def self.find(user, content, liked=true)
    user.likes.find_by("#{content.class.model_name.singular}_id": content.id, liked: liked)
  end

  def self.cancel(user, content, option = "like", liked = true)
    return if !Like.send("#{option}?", user, content)
    find(user, content, liked).destroy
    content["#{option}s_counter"] -= 1
    content.save
    user.likes.reload
  end

  def self.choice(user, content, option = "like", liked = true)
    option == "like" ? Like.cancel_dislike(user, content) : Like.cancel_like(user, content)
    return if Like.send("#{option}?", user, content)
    Like.create(user: user, "#{content.class.model_name.singular}": content, liked: liked)
    content["#{option}s_counter"] += 1
    content.save
    user.likes.reload
  end
end
