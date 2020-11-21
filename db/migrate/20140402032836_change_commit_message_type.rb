class ChangeCommitMessageType < ActiveRecord::Migration[4.2]
  def up
    change_column :tips, :commit_message, :text
  end

  def down
    change_column :tips, :commit_message, :string
  end
end
