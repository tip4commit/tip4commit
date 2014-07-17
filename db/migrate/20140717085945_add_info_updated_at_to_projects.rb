class AddInfoUpdatedAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :info_updated_at, :timestamp
  end
end
