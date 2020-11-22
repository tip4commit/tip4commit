# frozen_string_literal: true

class BitcoinTipper
  class << self
    def work_forever
      loop do
        work
      end
    end

    def work(withdraw = true)
      create_tips
      update_projects_info
      check_and_withdrawal_funds if withdraw
      auto_decide_older_tips
      refund_unclaimed_tips
      update_cache
    end

    def check_and_withdrawal_funds
      Rails.logger.info 'Traversing users...'
      users_waiting_for_withdrawal = 0
      User.find_each do |user|
        if user.ready_for_withdrawal?
          users_waiting_for_withdrawal += 1
          Rails.logger.info "User ##{user.id} is waiting for withdrawal"
        end
      end

      # if users_waiting_for_withdrawal > 2
      #   self.create_sendmany
      # end

      Rails.logger.info 'Traversing sendmanies...'
      Sendmany.where(txid: nil).each(&:send_transaction)
    end

    def auto_decide_older_tips
      Rails.logger.info 'Auto-deciding older tips...'
      Tip.auto_decide_older_tips
    end

    def refund_unclaimed_tips
      Rails.logger.info 'Refunding unclaimed tips...'
      Tip.refund_unclaimed
    end

    def create_tips
      Rails.logger.info 'Traversing projects...'
      Project.find_each do |project|
        if project.available_amount > 0
          Rails.logger.info " Project #{project.id} #{project.full_name}"
          project.tip_commits
        end
      end
    end

    def update_projects_info
      Rails.logger.info 'Updating projects info...'
      Project.order(info_updated_at: :desc).last(10).each do |project|
        Rails.logger.info " Project #{project.id} #{project.full_name}"
        project.update_info
        project.touch(:info_updated_at)
      end
    end

    def update_cache
      Rails.logger.info 'Updating projects cache...'
      Project.update_cache

      Rails.logger.info 'Updating users cache...'
      User.update_cache
    end

    def create_sendmany
      Rails.logger.info 'Creating sendmany'
      ActiveRecord::Base.transaction do
        sendmany = Sendmany.create
        outs = calculate_outputs
        sendmany.update_attribute :data, outs.to_json
        Rails.logger.info "  #{sendmany.inspect}"
      end
    end

    def calculate_outputs
      outputs = {}
      User.find_each do |user|
        next unless user.ready_for_withdrawal?

        user.tips.decided.unpaid.each do |tip|
          tip.update_attribute :sendmany_id, sendmany.id
          outputs[user.bitcoin_address] ||= 0
          outputs[user.bitcoin_address] += tip.amount
        end
      end
      outputs
    end
  end
end
