class SplitOrgStatusTypes < ActiveRecord::Migration
  def change
    add_column :organization_status_types, :category, :string
  end
end
