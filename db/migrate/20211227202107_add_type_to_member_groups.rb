class AddTypeToMemberGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :member_groups, :type, :string
  end
end
