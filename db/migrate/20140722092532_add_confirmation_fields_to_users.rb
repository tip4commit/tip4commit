# frozen_string_literal: true

class AddConfirmationFieldsToUsers < ActiveRecord::Migration[4.2]
  def change
    change_table :users, bulk: true do |t|
      t.column :confirmation_token, :string
      t.column :confirmation_sent_at, :timestamp
      t.column :confirmed_at, :timestamp
      t.column :unconfirmed_email, :string
    end
  end
end
