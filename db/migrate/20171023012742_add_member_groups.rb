class AddMemberGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :member_groups do |t|
      t.string :name
      t.string :group_type
    end

    create_table :member_group_memberships do |t|
      t.references :member, index: true
      t.references :member_groups, index: true
    end

    add_reference :elections, :member_group, index: true
  end
end
