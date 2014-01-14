class AddAvailableAmountCacheToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :available_amount_cache, :integer
  end
end
