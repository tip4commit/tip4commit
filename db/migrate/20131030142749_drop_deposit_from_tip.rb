class DropDepositFromTip < ActiveRecord::Migration
  def change
    remove_column :tips, :deposit_id
  end
end
