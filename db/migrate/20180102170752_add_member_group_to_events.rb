class AddMemberGroupToEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :member_group, index: true
  end
end
