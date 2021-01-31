# frozen_string_literal: true

class AddFeeSizeToDeposits < ActiveRecord::Migration[4.2]
  class Deposit < ApplicationRecord
  end

  def change
    reversible do |dir|
      change_table :deposits, bulk: true do |t|
        t.column :fee_size, :float
        dir.up { t.remove :duration }
        dir.down { t.column :duration, :integer }
      end

      # Update all existing deposits
      dir.up { Deposit.update_all(fee_size: CONFIG['our_fee']) }
    end
  end
end
