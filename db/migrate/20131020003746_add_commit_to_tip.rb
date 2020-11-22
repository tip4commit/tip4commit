# frozen_string_literal: true

class AddCommitToTip < ActiveRecord::Migration[4.2]
  def change
    add_column :tips, :commit, :string
  end
end
