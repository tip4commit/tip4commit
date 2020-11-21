class AddHoldTipsToProject < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :hold_tips, :boolean, default: false
  end
end
