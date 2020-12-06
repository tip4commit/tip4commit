# frozen_string_literal: true

class DropDepositFromTip < ActiveRecord::Migration[4.2]
  def up
    remove_column :tips, :deposit_id
  end

  def down
    add_reference :tips, :deposit, index: true
  end
end
