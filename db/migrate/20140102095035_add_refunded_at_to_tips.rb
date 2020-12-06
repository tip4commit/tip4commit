# frozen_string_literal: true

class AddRefundedAtToTips < ActiveRecord::Migration[4.2]
  def up
    change_table :tips, bulk: true do |t|
      t.column :refunded_at, :timestamp
      t.remove :is_refunded
    end
  end

  def down
    change_table :tips, bulk: true do |t|
      t.remove :refunded_at
      t.column :is_refunded, :boolean
    end
  end
end
