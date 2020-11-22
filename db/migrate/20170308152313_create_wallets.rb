# frozen_string_literal: true

class CreateWallets < ActiveRecord::Migration[4.2]
  def change
    create_table :wallets do |t|
      t.string :name
      t.string :xpub
      t.integer :last_address_index, default: 1, limit: 4

      t.timestamps null: false
    end
  end
end
