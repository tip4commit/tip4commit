class UpdateDecidedAtForExistingTips < ActiveRecord::Migration
  def up
    Tip.where.not(amount: nil).find_each do |tip|
      tip.update decided_at: tip.created_at
    end
  end
end
