class AddAmountToDeposit < ActiveRecord::Migration[4.2]
  def change
    add_column :deposits, :amount, :integer, :limit => 8
  end
end
