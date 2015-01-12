class AddDecidedAtToTips < ActiveRecord::Migration
  def change
    add_column :tips, :decided_at, :timestamp
  end
end