class RemovePaidOutFromDeposits < ActiveRecord::Migration
  def change
    remove_column :deposits, :paid_out, :integer, :limit => 8
    remove_column :deposits, :paid_out_at, :datetime
  end
end
