class AddBitcoinAddressToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :bitcoin_address, :string
  end
end
