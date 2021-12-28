class AddAncestryToMemberGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :member_groups, :ancestry, :string
    add_index :member_groups, :ancestry
  end
end
