class MakeDefaultBranchBlank < ActiveRecord::Migration
  def change
    change_column :projects, :branch, :string, default: nil
  end
end
