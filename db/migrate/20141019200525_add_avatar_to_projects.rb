class AddAvatarToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :avatar_url, :string
  end
end
