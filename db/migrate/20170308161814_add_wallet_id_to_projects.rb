class AddWalletIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :wallet_id, :integer
  end
end
