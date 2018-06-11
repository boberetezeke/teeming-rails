class AddOfficerAssignmentReasons < ActiveRecord::Migration[5.1]
  def change
    add_column :officer_assignments, :reason_for_start, :string
    add_column :officer_assignments, :reason_for_end, :string
  end
end
