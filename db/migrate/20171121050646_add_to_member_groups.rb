class AddToMemberGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :member_groups, :scope_type, :string
  end
end
