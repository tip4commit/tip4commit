class MakeDefaultBranchBlank < ActiveRecord::Migration[4.2]
  def change
    change_column :projects, :branch, :string, default: nil
  end
end
