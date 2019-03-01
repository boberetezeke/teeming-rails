class AddOfficerIdToRoleAssignments < ActiveRecord::Migration[5.0]
  def change
    add_reference :role_assignments, :officer, index: true
  end
end
