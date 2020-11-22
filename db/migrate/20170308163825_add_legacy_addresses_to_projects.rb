# frozen_string_literal: true

class AddLegacyAddressesToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :legacy_address, :string
  end
end
