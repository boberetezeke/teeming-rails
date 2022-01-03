class AddMemberGroupIdToOfficers < ActiveRecord::Migration[5.2]
  def change
    add_reference :officers, :member_group, index: true
    add_reference :notes, :member_group, index: true
  end
end
