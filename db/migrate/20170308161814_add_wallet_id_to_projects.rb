# frozen_string_literal: true

class AddWalletIdToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :wallet_id, :integer
  end
end
