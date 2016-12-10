class Sendmany < ActiveRecord::Base
  has_many :tips

  def total_amount
    JSON.parse(data).values.map(&:to_d).sum if data
  end

  def send_transaction
    return if txid || is_error

    update_attribute :is_error, true # it's a lock to prevent duplicates


    bitcoind = BitcoinRPC.new(CONFIG["bitcoind"]["rpc_connection_string"],false)

    begin
      txid = bitcoind.sendmany(
        CONFIG["bitcoind"]["account"],
        JSON.parse(data).map { |address, amount| {address => amount/1e8} }.inject(&:merge)
      )
      if txid.present?
        update_attribute :is_error, false
        update_attribute :txid, txid
      end
    rescue StandardError => e
      update_attribute :result, e.inspect
    end

  end

  def to_csv
    JSON.parse(self.data).map do |address, value|
      [address, value / 1e8].join(',')
    end.join("\n")
  end
end
