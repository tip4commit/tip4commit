# frozen_string_literal: true

class AddSomeFieldsToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :name, :string
    add_column :projects, :full_name, :string
    add_column :projects, :source_full_name, :string
    add_column :projects, :description, :string
    add_column :projects, :watchers_count, :integer
    add_column :projects, :language, :string
  end
end
