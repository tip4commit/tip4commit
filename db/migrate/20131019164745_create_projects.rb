class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :url
      t.string :bitcoin_address

      t.timestamps
    end
  end
end
