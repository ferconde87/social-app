class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, optional: true  
  belongs_to :comment, optional: true

  def like_content?(content)
    debugger
  end
end
