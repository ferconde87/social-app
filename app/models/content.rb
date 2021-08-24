module Content
  # belongs_to :post
  # belongs_to :user
  # has_many :likes, dependent: :destroy
  # default_scope -> { order(created_at: :desc) }
  # validates :content, presence: true, length: { maximum: 1000 }
  # validates :user_id, presence: true

  # Count likes
  def likes_count
    # likes.select{ |l| l.liked }.length
    # debugger
    likes_counter
  end

  # Count dislikes
  def dislikes_count
    # likes.select{ |l| !l.liked }.length
    dislikes_counter
  end
end
