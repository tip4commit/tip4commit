class BitcoinTipper
  def self.work_forever
    while true do
      self.work
    end
  end

  def self.work withdraw = true
    Rails.logger.info "Traversing projects..."
    Project.find_each do |project|
      if project.available_amount > 0
        Rails.logger.info " Project #{project.id} #{project.full_name}"
        project.tip_commits
      end
    end

    Rails.logger.info "Updating projects info..."
    Project.order(:info_updated_at => :desc).last(100).each do |project|
      Rails.logger.info " Project #{project.id} #{project.full_name}"
      project.update_info
      project.touch(:info_updated_at)
    end

    if withdraw
      Rails.logger.info "Traversing users..."
      users_waiting_for_withdrawal = 0
      User.find_each do |user|
        if user.bitcoin_address.present? && user.balance > CONFIG["min_payout"]
          users_waiting_for_withdrawal += 1
          Rails.logger.info "User ##{user.id} is waiting for withdrawal"
        end
      end

      if users_waiting_for_withdrawal > 2
        self.create_sendmany
      end

      Rails.logger.info "Traversing sendmanies..."
      Sendmany.where(txid: nil).each do |sendmany|
        sendmany.send_transaction
      end
    end

    Rails.logger.info "Auto-deciding older tips..."
    Tip.auto_decide_older_tips

    Rails.logger.info "Refunding unclaimed tips..."
    Tip.refund_unclaimed

    Rails.logger.info "Updating projects cache..."
    Project.update_cache

    Rails.logger.info "Updating users cache..."
    User.update_cache
  end

  def self.create_sendmany
    Rails.logger.info "Creating sendmany"
    ActiveRecord::Base.transaction do
      sendmany = Sendmany.create
      outs = {}
      User.find_each do |user|
        if user.bitcoin_address.present? && user.balance > CONFIG["min_payout"]
          user.tips.decided.unpaid.each do |tip|
            tip.update_attribute :sendmany_id, sendmany.id
            outs[user.bitcoin_address] = outs[user.bitcoin_address].to_i + tip.amount
          end
        end
      end
      sendmany.update_attribute :data, outs.to_json
      Rails.logger.info "  #{sendmany.inspect}"
    end
  end

end
