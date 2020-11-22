# frozen_string_literal: true

class RemovePaidOutFromDeposits < ActiveRecord::Migration[4.2]
  def change
    remove_column :deposits, :paid_out, :integer, :limit => 8
    remove_column :deposits, :paid_out_at, :datetime
  end
end
