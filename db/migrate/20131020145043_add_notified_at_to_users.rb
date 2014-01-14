class AddNotifiedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notified_at, :datetime
  end
end
