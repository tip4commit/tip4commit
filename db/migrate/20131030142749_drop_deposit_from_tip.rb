class DropDepositFromTip < ActiveRecord::Migration[4.2]
  def change
    remove_column :tips, :deposit_id
  end
end
