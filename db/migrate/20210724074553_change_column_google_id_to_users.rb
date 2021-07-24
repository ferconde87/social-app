class ChangeColumnGoogleIdToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :google_id, :string
  end
end
