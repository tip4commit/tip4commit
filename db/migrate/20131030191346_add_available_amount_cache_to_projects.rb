# frozen_string_literal: true

class AddAvailableAmountCacheToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :available_amount_cache, :integer
  end
end
