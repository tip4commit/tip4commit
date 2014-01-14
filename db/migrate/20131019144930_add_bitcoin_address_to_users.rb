class AddBitcoinAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bitcoin_address, :string
  end
end
