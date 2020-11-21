class Deposit < ApplicationRecord
  belongs_to :project

  CONFIRMATIONS_NEEDED = 3

  scope :confirmed, -> { where("confirmations >= #{CONFIRMATIONS_NEEDED}") }
  scope :unconfirmed, -> { where("confirmations < #{CONFIRMATIONS_NEEDED}") }

  def confirmed?
    confirmations.to_i >= CONFIRMATIONS_NEEDED
  end

  def fee
    (amount * fee_size).to_i
  end

  def available_amount
    [amount - fee, 0].max
  end

  before_create do
    self.fee_size = CONFIG['our_fee']
  end

  def project_name
    project.full_name
  end
end
