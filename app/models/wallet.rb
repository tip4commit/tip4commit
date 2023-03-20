# frozen_string_literal: true

class Wallet < ApplicationRecord
  validates :name, :xpub, presence: true

  def generate_address
    address = address_by_index(last_address_index)
    self.last_address_index += 1
    save
    address
  end

  def address_by_index(index)
    hd_wallet.node_for_path("0/#{index}.pub").to_address
  end

  private

  def hd_wallet
    MoneyTree::Node.from_bip32(xpub)
  end
end
