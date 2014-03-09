class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.belongs_to :project, index: true
      t.string :login

      t.timestamps
    end
  end
end
