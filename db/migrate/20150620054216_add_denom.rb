class AddDenom < ActiveRecord::Migration
  def change
    add_column :users, :denom, :integer, default: 0
  end
end
