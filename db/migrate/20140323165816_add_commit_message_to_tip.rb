# frozen_string_literal: true

class AddCommitMessageToTip < ActiveRecord::Migration[4.2]
  def change
    add_column :tips, :commit_message, :string
  end
end
