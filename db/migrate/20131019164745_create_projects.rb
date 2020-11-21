class CreateProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :projects do |t|
      t.string :url
      t.string :bitcoin_address

      t.timestamps
    end
  end
end
