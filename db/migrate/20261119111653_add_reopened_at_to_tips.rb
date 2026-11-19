# frozen_string_literal: true

class AddReopenedAtToTips < ActiveRecord::Migration[6.1]
  def change
    add_column :tips, :reopened_at, :datetime
  end
end
