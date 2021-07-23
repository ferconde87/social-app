class AddGoogleAndFacebookToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :google_id, :Integer
    add_column :users, :facebook_id, :Integer
  end
  add_index :users, :google_id
  add_index :users, :facebook_id
end
