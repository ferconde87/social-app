class Comment < ApplicationRecord
  include Content
  belongs_to :post
  belongs_to :user
  # has_many :likes, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :user_id, presence: true
end
