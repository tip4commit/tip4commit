class AddBranchToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :branch, :string, default: 'master'
  end
end
