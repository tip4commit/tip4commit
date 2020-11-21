class AddLastCommitToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :last_commit, :string
  end
end
