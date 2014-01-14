class AddUnsubscribedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :unsubscribed, :boolean
  end
end
