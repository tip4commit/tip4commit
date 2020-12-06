# frozen_string_literal: true

class AddSomeFieldsToProjects < ActiveRecord::Migration[4.2]
  def change
    change_table :projects, bulk: true do |t|
      t.column :name, :string
      t.column :full_name, :string
      t.column :source_full_name, :string
      t.column :description, :string
      t.column :watchers_count, :integer
      t.column :language, :string
    end
  end
end
