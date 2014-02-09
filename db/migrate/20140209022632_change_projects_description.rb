class ChangeProjectsDescription < ActiveRecord::Migration
  def up
    change_column :projects, :description, :text, :limit => nil
  end
  def down
    change_column :projects, :description, :string
  end
end
