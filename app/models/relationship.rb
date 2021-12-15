class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  def self.follow(user, other_user)
    user.following << other_user
  end

  def self.unfollow(user, other_user)
    user.following.delete(other_user)
  end

  def self.following?(user, other_user)
    user.following.include?(other_user)
  end

  def self.followers?(user, other_user)
    user.followers.include?(other_user)
  end
end
