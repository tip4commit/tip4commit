# frozen_string_literal: true

class Tip < ApplicationRecord
  belongs_to :user
  belongs_to :sendmany
  belongs_to :project, inverse_of: :tips

  class AlreadyPaid < StandardError; end
  class InsufficientFunds < StandardError; end

  # Refund month starts at the later of decided_at and reopened_at (portable: no GREATEST).
  REFUND_CLOCK_SQL = 'CASE WHEN tips.reopened_at IS NOT NULL AND tips.reopened_at > tips.decided_at ' \
                     'THEN tips.reopened_at ELSE tips.decided_at END'

  AVAILABLE_AMOUNTS = [
    ['undecided', ''],
    ['free',      0],
    ['tiny',      0.1],
    ['small',     0.5],
    ['normal',    1],
    ['big',       2],
    ['huge',      5]
  ].freeze

  validates :amount, numericality: { greater_or_equal_than: 0, allow_nil: true }

  scope :not_sent, -> { where(sendmany_id: nil) }

  def not_sent?
    sendmany_id.nil?
  end

  scope :unpaid, -> { non_refunded.not_sent }

  def unpaid?
    non_refunded? and not_sent?
  end

  scope :to_pay, -> { unpaid.decided.not_free.with_address }

  def to_pay?
    unpaid? and decided? and !free? and with_address?
  end

  scope :free,          -> { where('amount = 0') }
  scope :not_free,      -> { where('amount > 0') }

  def free?
    amount.zero?
  end

  scope :paid, -> { where.not(sendmany_id: nil) }

  def paid?
    !!sendmany_id
  end

  scope :refunded, -> { where.not(refunded_at: nil) }

  def refunded?
    !!refunded_at
  end

  scope :non_refunded, -> { where(refunded_at: nil) }

  def non_refunded?
    !refunded?
  end

  scope :unclaimed, -> { joins(:user).unpaid.where('users.bitcoin_address' => ['', nil]) }

  def claimed?
    paid? || user.bitcoin_address.present?
  end

  def unclaimed?
    !claimed?
  end

  scope :with_address, -> { joins(:user).where.not('users.bitcoin_address' => ['', nil]) }

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

  def self.refund_unclaimed
    unclaimed.non_refunded
             .where.not(decided_at: nil)
             .where("#{REFUND_CLOCK_SQL} < ?", 1.month.ago)
             .find_each do |tip|
      tip.touch :refunded_at
    end
  end

  def self.auto_decide_older_tips
    undecided.non_refunded
             .where('COALESCE(tips.reopened_at, tips.created_at) < ?', 1.month.ago)
             .find_each do |tip|
      tip.amount_percentage = 1
      tip.save
    end
  end

  # Puts an unpaid tip back to undecided and restarts its one-month clock.
  # Writes with update_columns on purpose: the callbacks must not run. The project's
  # cached balance is refreshed afterwards (reopen! and unrefund! both change it).
  # Works on a tip whose project was soft-deleted (project is then nil).
  def reopen!
    with_lock do
      raise AlreadyPaid, "Tip #{id} is already paid" if paid?

      now = Time.zone.now
      update_columns(amount: nil, decided_at: nil, refunded_at: nil, reopened_at: now, updated_at: now)
      refresh_project_cache
    end
  end

  # Undoes a refund, keeping amount and decided_at, and restarts the one-month clock.
  def unrefund!
    with_lock do
      raise AlreadyPaid, "Tip #{id} is already paid" if paid?
      raise ArgumentError, "Tip #{id} is not refunded" unless refunded?

      available = project.available_amount
      raise InsufficientFunds, "Tip #{id}: #{amount} needed, #{available} available" if available < amount.to_i

      now = Time.zone.now
      update_columns(refunded_at: nil, reopened_at: now, updated_at: now)
      refresh_project_cache
    end
  end

  def commit_url
    project.commit_url(commit)
  end

  def amount_percentage
    nil
  end

  def amount_percentage=(percentage)
    return if decided?
    return if percentage.blank?
    return unless AVAILABLE_AMOUNTS.map(&:last).compact.map(&:to_s).include?(percentage.to_s)

    self.amount = (project.available_amount * (percentage.to_f / 100)).ceil
  end

  def check_amount_against_project
    return unless amount && amount_changed?

    available_amount = project.available_amount
    available_amount -= amount_was if amount_was

    return if amount <= available_amount

    raise "Not enough funds on project to save #{inspect} (available: #{available_amount}). Project #{project.inspect} available_amount: #{project.available_amount} #{project.tips.count} tips: #{project.tips.map(&:amount).join(', ')}"
  end

  def touch_decided_at_if_decided
    self.decided_at = Time.zone.now if amount_changed? && decided?
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

  private

  # update_column skips validations, so the cache write cannot be silently refused the way
  # Project#update_cache (update) is on a project that fails validation. A soft-deleted
  # project (nil here) has no cache to refresh.
  def refresh_project_cache
    project&.update_column(:available_amount_cache, project.available_amount)
  end
end
