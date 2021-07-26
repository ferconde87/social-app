class Post < ApplicationRecord
  has_many :likes, dependent: :destroy
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 1000 }
  validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'],
                    size: { less_than: 5.megabytes, message: "should be less than 5MB" }

  # Returns a resized image for display.
  def display_image
    image.variant(resize_to_limit: [800, 600])
  end
  
end
