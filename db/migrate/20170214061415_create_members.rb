class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.integer :databank_id
      t.string :first_name
      t.string :last_name
      t.string :middle_initial
      t.string :company
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :home_phone
      t.string :work_phone
      t.string :mobile_phone
      t.string :email

      t.timestamps
    end
  end
end
