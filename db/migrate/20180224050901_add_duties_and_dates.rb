class AddDutiesAndDates < ActiveRecord::Migration[5.0]
  def change
    add_column :officer_assignments, :start_date, :date
    add_column :officer_assignments, :end_date, :date
    add_column :officers, :responsibilities, :text
  end
end
