# frozen_string_literal: true

class UpdateDecidedAtForExistingTips < ActiveRecord::Migration[4.2]
  def up
    Tip.where.not(amount: nil).find_each do |tip|
      tip.update decided_at: tip.created_at
    end
  end
end
