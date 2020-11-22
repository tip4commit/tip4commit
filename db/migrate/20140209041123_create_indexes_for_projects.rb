# frozen_string_literal: true

class CreateIndexesForProjects < ActiveRecord::Migration[4.2]
  def change
    add_index :projects, :full_name,                :unique => true
    add_index :projects, :github_id,                :unique => true
  end
end
