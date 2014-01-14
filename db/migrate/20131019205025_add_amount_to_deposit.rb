class AddAmountToDeposit < ActiveRecord::Migration
  def change
    add_column :deposits, :amount, :integer, :limit => 8
  end
end
