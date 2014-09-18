class AddDisableNotificationsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :disable_notifications, :boolean
  end
end
