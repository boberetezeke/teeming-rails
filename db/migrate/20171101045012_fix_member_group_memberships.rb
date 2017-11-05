class FixMemberGroupMemberships < ActiveRecord::Migration[5.0]
  def change
    rename_column :member_group_memberships, :member_groups_id, :member_group_id
  end
end
