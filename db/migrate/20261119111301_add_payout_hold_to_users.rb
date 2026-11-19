# frozen_string_literal: true

class AddPayoutHoldToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :payout_hold, :boolean, null: false, default: false
    add_column :users, :payout_hold_reason, :string
  end
end
