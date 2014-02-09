class CreateIndexesForProjects < ActiveRecord::Migration
  def change
    add_index :projects, :full_name,                :unique => true
    add_index :projects, :github_id,                :unique => true
  end
end
