class AddUnsubscribedToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :unsubscribed, :boolean
  end
end
