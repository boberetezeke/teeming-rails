class AddOfficerAssignmentsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :officer_assignments do |t|
      t.references :user, index: true
      t.references :officer, index: true
    end
  end
end
