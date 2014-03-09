class AddCommitMessageToTip < ActiveRecord::Migration
  def change
    add_column :tips, :commit_message, :string
  end
end
