class AddProjectToTip < ActiveRecord::Migration[4.2]
  def change
    add_reference :tips, :project, index: true
  end
end
