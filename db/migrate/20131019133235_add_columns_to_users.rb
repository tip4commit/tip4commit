# frozen_string_literal: true

class AddColumnsToUsers < ActiveRecord::Migration[4.2]
  def change
    change_table :users, bulk: true do |t|
      t.column :nickname, :string
      t.column :name, :string
      t.column :image, :string
    end
  end
end
