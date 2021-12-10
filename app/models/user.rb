class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes
  has_many :posts_liked, -> {where(likes: {liked:true,comment:nil})}, through: :likes, source: :post
  has_many :posts_disliked, -> {where(likes: {liked:false,comment:nil})}, through: :likes, source: :post
  has_many :comments_liked, -> {where(likes: {liked:true,post:nil})}, through: :likes, source: :comment
  has_many :comments_disliked, -> {where(likes: {liked:false,post:nil})}, through: :likes, source: :comment
  has_one_attached :image
  attr_accessor :remember_token, :activation_token, :password_reset_token
  before_save :downcase_email
  before_create :create_activation_digest

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
                    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_many :active_relationships, class_name: "Relationship", 
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent: :destroy
                                  
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships
                                
  has_secure_password

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end  

  def forget?
    remember_digest == nil
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_password_reset_digest
    self.password_reset_token = User.new_token
    update_columns(
      password_reset_digest: User.digest(password_reset_token),
      password_reset_sent_at: Time.zone.now
    )
  end
  
  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    password_reset_sent_at < 2.hours.ago
  end

  # Defines a proto-feed.
  def feed
    #Post.where("user_id IN (?)", following_ids)  # <= this way doesn't scale! cuz it's pulling all users in a potentially big array 'self.following_ids'
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    # Post.includes({comments: :likes}, :likes).where("user_id IN (#{following_ids})", user_id: id) # Using eager loading...
    Post.includes(:comments => :user).where("user_id IN (#{following_ids})", user_id: id)
  end

  # Follows a user.
  def follow(other_user)
    following << other_user
  end
  
  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  # Returns true if the other user is follower of the current user
  def followers?(other_user)
    followers.include?(other_user)
  end

  # Update the attribute name with value and activated the user
  def activate_with_atttribute(name, value)
    update_columns("#{name}": value, activated: true, activated_at: Time.zone.now)
  end

  # User likes content ?
  def like?(content)
    # send("#{content.class.model_name.plural}_liked").include?(content)
    # !likes.find_by("#{content.class.model_name.singular}_id": content.id, liked: true).nil?
    !likes.find {|like| like.send("#{content.class.model_name.singular}_id") == content.id && like.liked == true}.nil?
  end

  # User dislikes post ?
  def dislike?(content)
    # send("#{content.class.model_name.plural}_disliked").include?(content)
    # !likes.find_by("#{content.class.model_name.singular}_id": content.id, liked: false).nil?
    !likes.find {|like| like.send("#{content.class.model_name.singular}_id") == content.id && like.liked == false }.nil?
  end

  # User likes a post
  def like(content)
    # posts_liked << post if !like? post
    if !like? content
      # send("#{content.class.model_name.plural}_liked") << content if !like? content
      likes.create!("#{content.class.model_name.singular}_id": content.id, liked: true)
      content.likes_counter += 1
      content.save
    end
    if dislike? content
      # send("#{content.class.model_name.plural}_disliked").delete content 
      likes.find_by("#{content.class.model_name.singular}_id": content.id, liked: false).destroy
      content.dislikes_counter -= 1
      content.save
    end
    likes.reload
  end
  
  # User dislikes a post
  def dislike(content)
    if !dislike? content
      # send("#{content.class.model_name.plural}_disliked") << content 
      likes.create!("#{content.class.model_name.singular}_id": content.id, liked: false)
      content.dislikes_counter += 1
      content.save
    end
    if like? content
      # send("#{content.class.model_name.plural}_liked").delete content 
      likes.find_by("#{content.class.model_name.singular}_id": content.id, liked: true).destroy
      content.likes_counter -= 1
      content.save
    end
    likes.reload
  end

  # User cancel a previous like post
  def cancel_like(content)
    if like? content
      # send("#{content.class.model_name.plural}_liked").delete content
      likes.find_by("#{content.class.model_name.singular}_id": content.id, liked: true).destroy
      content.likes_counter -= 1
      content.save
      likes.reload
    end
  end

  # User cancel a previous dislike post
  def cancel_dislike(content)
    if dislike? content
      # send("#{content.class.model_name.plural}_disliked").delete content
      likes.find_by("#{content.class.model_name.singular}_id": content.id, liked: false).destroy
      content.dislikes_counter -= 1
      content.save
      likes.reload
    end
  end
  
  private
  
  # Converts email to all lower-case.
  def downcase_email
    email.downcase!
  end
  
  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
