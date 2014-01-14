class CreateSendmanies < ActiveRecord::Migration
  def change
    create_table :sendmanies do |t|
      t.string :txid
      t.text :data
      t.string :result
      t.boolean :is_error

      t.timestamps
    end
  end
end
