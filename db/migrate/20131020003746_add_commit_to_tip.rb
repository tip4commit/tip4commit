class AddCommitToTip < ActiveRecord::Migration
  def change
    add_column :tips, :commit, :string
  end
end
