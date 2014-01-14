class AddRefundedAtToTips < ActiveRecord::Migration
  def change
    add_column :tips, :refunded_at, :timestamp
    remove_column :tips, :is_refunded, :boolean
  end
end
