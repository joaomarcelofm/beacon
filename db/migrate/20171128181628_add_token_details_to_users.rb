class AddTokenDetailsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :token, :string
    add_column :users, :token_expiry, :boolean
  end
end
