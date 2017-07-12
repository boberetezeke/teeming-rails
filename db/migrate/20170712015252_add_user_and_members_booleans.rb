class AddUserAndMembersBooleans < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :run_for_state_board, :boolean
    add_column :users, :interested_in_volunteering, :boolean
    add_column :members, :interested_in_starting_chapter, :boolean
  end
end
