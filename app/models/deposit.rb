class Deposit < ActiveRecord::Base
  belongs_to :project

  def fee
    (amount * fee_size).to_i
  end

  def available_amount
    [amount - fee, 0].max
  end

  before_create do
    self.fee_size = CONFIG["our_fee"]
  end

end
