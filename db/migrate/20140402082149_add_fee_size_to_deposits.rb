class AddFeeSizeToDeposits < ActiveRecord::Migration[4.2]
  class Deposit < ActiveRecord::Base
  end

  def change
    add_column :deposits, :fee_size, :float
    remove_column :deposits, :duration, :integer
    reversible do |dir|
      # Update all existing deposits
      dir.up { Deposit.update_all(fee_size: CONFIG['our_fee']) }
    end
  end
end
