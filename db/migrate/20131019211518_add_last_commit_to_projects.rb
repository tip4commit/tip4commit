class AddLastCommitToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :last_commit, :string
  end
end
