# frozen_string_literal: true

class RemovePaidOutFromDeposits < ActiveRecord::Migration[4.2]
  def up
    change_table :deposits, bulk: true do |t|
      t.remove :paid_out
      t.remove :paid_out_at
    end
  end

  def down
    change_table :deposits, bulk: true do |t|
      t.add :paid_out, :integer, limit: 8
      t.add :paid_out_at, :datetime
    end
  end
end
