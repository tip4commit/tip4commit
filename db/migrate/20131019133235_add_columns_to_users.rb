class AddColumnsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :nickname, :string
    add_column :users, :name, :string
    add_column :users, :image, :string
  end
end
