# frozen_string_literal: true

class AddBranchToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :branch, :string, default: 'master'
  end
end
