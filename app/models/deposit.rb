class Deposit < ActiveRecord::Base
  belongs_to :project

  def fee
    (amount * CONFIG["our_fee"]).to_i
  end

  def available_amount
    [amount - fee, 0].max
  end

end