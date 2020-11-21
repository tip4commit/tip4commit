class AddDecidedAtToTips < ActiveRecord::Migration[4.2]
  def change
    add_column :tips, :decided_at, :timestamp
  end
end
