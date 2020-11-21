class AddRefundedAtToTips < ActiveRecord::Migration[4.2]
  def change
    add_column :tips, :refunded_at, :timestamp
    remove_column :tips, :is_refunded, :boolean
  end
end
