class AddRosterStatusToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :roster_status, :string
  end
end
