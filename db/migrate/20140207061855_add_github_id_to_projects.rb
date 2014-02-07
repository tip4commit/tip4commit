class AddGithubIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :github_id, :string
  end
end
