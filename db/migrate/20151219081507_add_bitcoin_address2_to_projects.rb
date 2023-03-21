# frozen_string_literal: true

class AddBitcoinAddress2ToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :bitcoin_address2, :string
    add_index :projects, :bitcoin_address2
    reversible do |dir|
      dir.up do
        Project.find_each(&:generate_address2)
      end
    end
  end
end
