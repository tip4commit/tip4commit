class Tip < ActiveRecord::Base
  belongs_to :user
  belongs_to :sendmany
  belongs_to :project

  validates :amount, numericality: { greater_than: 0 }

  scope :unpaid,        -> { non_refunded.
                             where(sendmany_id: nil) }

  scope :paid,          -> { where.not(sendmany_id: nil) }

  scope :refunded,      -> { where.not(refunded_at: nil) }

  scope :non_refunded,  -> { where(refunded_at: nil) }

  scope :unclaimed,     -> { joins(:user).
                             unpaid.
                             where('users.bitcoin_address' => ['', nil]) }

  def self.refund_unclaimed
    unclaimed.non_refunded.
    where('tips.created_at < ?', Time.now - 1.month).
    find_each do |tip|
      tip.touch :refunded_at
    end
  end
end
