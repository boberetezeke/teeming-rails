class AddOfficersToMemberGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :member_groups, :organization_id, :integer
    add_index  :member_groups, :organization_id
  end
end
