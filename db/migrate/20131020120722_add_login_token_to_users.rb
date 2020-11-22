# frozen_string_literal: true

class AddLoginTokenToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :login_token, :string
  end
end
