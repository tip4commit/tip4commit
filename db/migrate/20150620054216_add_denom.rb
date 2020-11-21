class AddDenom < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :denom, :integer, default: 0
  end
end
