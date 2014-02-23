class AddProjectHost < ActiveRecord::Migration
  class Project < ActiveRecord::Base
  end

  def change
    add_column :projects, :host, :string, default: 'github'

    # Update all existing projects
    Project.where(host: nil).update_all(host: 'github')
  end
end
