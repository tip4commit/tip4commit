class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.references :deposit, index: true
      t.references :user, index: true
      t.integer :amount, :limit => 8
      t.references :sendmany, index: true
      t.boolean :is_refunded

      t.timestamps
    end
  end
end
