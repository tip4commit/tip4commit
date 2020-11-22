# frozen_string_literal: true

class AddInfoUpdatedAtToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :info_updated_at, :timestamp
  end
end
