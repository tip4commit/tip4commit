class AddHoldTipsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :hold_tips, :boolean, default: false
  end
end
