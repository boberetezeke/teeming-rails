class AddOfficers < ActiveRecord::Migration[5.0]
  def change
    create_table :officers do |t|
      t.string :officer_type
      t.date :start_date
      t.date :end_date
      t.references :member, index: true
      t.references :chapter, index: true
    end
  end
end
