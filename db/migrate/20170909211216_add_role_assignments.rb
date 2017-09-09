class AddRoleAssignments < ActiveRecord::Migration[5.0]
  def up
    add_reference :users, :role, index: true
    remove_column :roles, :user_id
  end

  def down
    add_reference :roles, :user, index: true
    remove_column :users, :role_id
  end
end
