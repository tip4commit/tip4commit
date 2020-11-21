class ChangeProjectsDescription < ActiveRecord::Migration[4.2]
  def up
    change_column :projects, :description, :text, :limit => nil
  end

  def down
    change_column :projects, :description, :string
  end
end
