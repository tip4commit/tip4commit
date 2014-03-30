class CreateTippingPoliciesTexts < ActiveRecord::Migration
  def change
    create_table :tipping_policies_texts do |t|
      t.belongs_to :project, index: true
      t.belongs_to :user, index: true
      t.text :text

      t.timestamps
    end
  end
end
