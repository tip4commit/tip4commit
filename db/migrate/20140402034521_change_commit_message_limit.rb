# frozen_string_literal: true

class ChangeCommitMessageLimit < ActiveRecord::Migration[4.2]
  def up
    change_column :tips, :commit_message, :text, limit: nil
  end

  def down
    change_column :tips, :commit_message, :text
  end
end
