# frozen_string_literal: true

class AddNotifiedAtToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :notified_at, :datetime
  end
end
