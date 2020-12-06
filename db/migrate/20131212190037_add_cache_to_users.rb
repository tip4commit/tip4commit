# frozen_string_literal: true

class AddCacheToUsers < ActiveRecord::Migration[4.2]
  def change
    change_table :users, bulk: true do |t|
      t.column :commits_count, :integer, default: 0
      t.column :withdrawn_amount, :integer, limit: 8, default: 0
    end
  end
end
