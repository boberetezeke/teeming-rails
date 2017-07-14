class FixUpMemberToUser < ActiveRecord::Migration[5.0]
  def change
    remove_reference :members, :users
    add_reference :members, :user
  end
end
