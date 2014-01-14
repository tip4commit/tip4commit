class AddCacheToUsers < ActiveRecord::Migration
  def change
    add_column :users, :commits_count, :integer, default: 0
    add_column :users, :withdrawn_amount, :integer, limit: 8, default: 0
  end
end
