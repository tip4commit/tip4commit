class ChangeCommitMessageLimit < ActiveRecord::Migration
  def up
    change_column :tips, :commit_message, :text, limit: nil
  end
  def down
    change_column :tips, :commit_message, :text
  end
end
