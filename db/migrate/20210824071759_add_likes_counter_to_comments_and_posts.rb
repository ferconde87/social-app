class AddLikesCounterToCommentsAndPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :likes_counter, :integer, default: 0
    add_column :comments, :dislikes_counter, :integer, default: 0
    add_column :posts, :likes_counter, :integer, default: 0
    add_column :posts, :dislikes_counter, :integer, default: 0
  end
end
