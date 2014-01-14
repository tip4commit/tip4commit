class AddProjectToTip < ActiveRecord::Migration
  def change
    add_reference :tips, :project, index: true
  end
end
