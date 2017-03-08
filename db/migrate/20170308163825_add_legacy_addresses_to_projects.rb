class AddLegacyAddressesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :legacy_address, :string
  end
end
