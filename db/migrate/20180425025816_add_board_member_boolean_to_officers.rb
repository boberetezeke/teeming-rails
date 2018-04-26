class AddBoardMemberBooleanToOfficers < ActiveRecord::Migration[5.1]
  def change
    add_column :officers, :is_board_member, :boolean
    add_column :officers, :is_executive_committee_member, :boolean
  end
end
