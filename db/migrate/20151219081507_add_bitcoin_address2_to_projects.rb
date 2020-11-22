# frozen_string_literal: true

class AddBitcoinAddress2ToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :bitcoin_address2, :string, index: true
    reversible do |dir|
      dir.up do
        Project.find_each do |project|
          project.generate_address2
        end
      end
    end
  end
end
