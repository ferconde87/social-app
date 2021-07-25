class AddGoogleAndFacebookToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :google_id, :string
    add_column :users, :facebook_id, :string
  end
  add_index :users, :google_id
  add_index :users, :facebook_id
end
