class Tip < ActiveRecord::Base
  belongs_to :user
  belongs_to :sendmany
  belongs_to :project, inverse_of: :tips

  AVAILABLE_AMOUNTS = [
    ['undecided', ""],
    ['free',      0],
    ['tiny',      0.1],
    ['small',     0.5],
    ['normal',    1],
    ['big',       2],
    ['huge',      5]
  ]

  validates :amount, numericality: { greater_or_equal_than: 0, allow_nil: true }

  scope :not_sent,      -> { where(sendmany_id: nil) }
  def not_sent?
    sendmany_id.nil?
  end

  scope :unpaid,        -> { non_refunded.not_sent }
  def unpaid?
    non_refunded? and not_sent?
  end

  scope :to_pay,        -> { unpaid.decided.not_free.with_address }
  def to_pay?
    unpaid? and decided? and !free? and with_address?
  end

  scope :free,          -> { where('amount = 0') }
  scope :not_free,      -> { where('amount > 0') }
  def free?
    amount == 0
  end

  scope :paid,          -> { where.not(sendmany_id: nil) }
  def paid?
    !!sendmany_id
  end

  scope :refunded,      -> { where.not(refunded_at: nil) }
  def refunded?
    !!refunded_at
  end

  scope :non_refunded,  -> { where(refunded_at: nil) }
  def non_refunded?
    !refunded?
  end

  scope :unclaimed,     -> { joins(:user).
                             unpaid.
                             where('users.bitcoin_address' => ['', nil]) }
  def claimed?
    paid? || user.bitcoin_address.present?
  end
  def unclaimed?
    !claimed?
  end

  scope :with_address,  -> { joins(:user).where.not('users.bitcoin_address' => ['', nil]) }
  def with_address?
    user.bitcoin_address.present?
  end

  scope :decided,       -> { where.not(amount: nil) }
  scope :undecided,     -> { where(amount: nil) }
  def decided?
    !!amount
  end
  def undecided?
    !decided?
  end

  before_save :check_amount_against_project
  before_save :touch_decided_at_if_decided
  after_save :notify_user_if_just_decided

  def self.refund_unclaimed
    unclaimed.non_refunded.
    where.not(decided_at: nil).
    where('tips.decided_at < ?', 1.month.ago).
    find_each do |tip|
      tip.touch :refunded_at
    end
  end

  def self.auto_decide_older_tips
    undecided.non_refunded.
    where('tips.created_at < ?', 1.month.ago).
    find_each do |tip|
      tip.amount_percentage = 1
      tip.save
    end
  end

  def commit_url
    project.commit_url(commit)
  end

  def amount_percentage
    nil
  end

  def amount_percentage=(percentage)
    if undecided? and percentage.present? and AVAILABLE_AMOUNTS.map(&:last).compact.map(&:to_s).include?(percentage.to_s)
      self.amount = (project.available_amount * (percentage.to_f / 100)).ceil
    end
  end

  def notify_user
    if amount && amount > 0 && user.bitcoin_address.blank? &&
        !user.unsubscribed && !project.disable_notifications &&
        user.balance > 21000000*1e8
      if user.notified_at.nil? or user.notified_at < 30.days.ago
        begin
          UserMailer.new_tip(user, self).deliver
          user.touch :notified_at
        rescue Net::SMTPServerBusy => e
          Rails.logger.info "Error: #{e.class}: #{e.message}"
        end
      end
    end
  end

  def notify_user_if_just_decided
    notify_user if amount_was.nil? and amount
  end

  def check_amount_against_project
    if amount && amount_changed?
      available_amount = project.available_amount
      available_amount -= amount_was if amount_was
      if amount > available_amount
        raise "Not enough funds on project to save #{inspect} (available: #{available_amount}). Project #{project.inspect} available_amount: #{project.available_amount} #{project.tips.count} tips: #{project.tips.map(&:amount).join(', ')}"
      end
    end
  end

  def touch_decided_at_if_decided
    self.decided_at = Time.now if amount_changed? && decided?
  end

  def project_name
    project.full_name
  end

  def user_name
    user.display_name
  end

  def txid
    try(:sendmany).try(:txid)
  end

end
