class Wallet < ActiveRecord::Base

  validates :name, :xpub, presence: true

  def generate_address
    address = hd_wallet.node_for_path("0/#{last_address_index}.pub").to_address
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
