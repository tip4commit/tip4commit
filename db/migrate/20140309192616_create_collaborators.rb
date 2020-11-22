# frozen_string_literal: true

class CreateCollaborators < ActiveRecord::Migration[4.2]
  def change
    create_table :collaborators do |t|
      t.belongs_to :project, index: true
      t.string :login

      t.timestamps
    end
  end
end
