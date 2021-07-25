class AddGoogleFacebookTwitterToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :google_id, :string
    add_column :users, :facebook_id, :string
    add_column :users, :twitter_id, :string
    add_index :users, :google_id
    add_index :users, :facebook_id
    add_index :users, :twitter_id
  end
end
