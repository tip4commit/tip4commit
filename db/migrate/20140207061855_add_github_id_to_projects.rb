# frozen_string_literal: true

class AddGithubIdToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :github_id, :string
  end
end
