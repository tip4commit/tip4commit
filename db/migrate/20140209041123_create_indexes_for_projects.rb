# frozen_string_literal: true

class CreateIndexesForProjects < ActiveRecord::Migration[4.2]
  def change
    change_table :projects, bulk: true do |t|
      t.index :full_name, unique: true
      t.index :github_id, unique: true
    end
  end
end
