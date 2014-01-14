class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.references :project, index: true
      t.string :txid
      t.integer :confirmations
      t.integer :duration, :default => 30.days.to_i
      t.integer :paid_out, :limit => 8
      t.datetime :paid_out_at

      t.timestamps
    end
  end
end
