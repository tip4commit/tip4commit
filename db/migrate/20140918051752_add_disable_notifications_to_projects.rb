class AddDisableNotificationsToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :disable_notifications, :boolean
  end
end
