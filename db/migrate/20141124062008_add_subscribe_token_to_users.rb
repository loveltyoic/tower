class AddSubscribeTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscribe_token, :string
  end
end
