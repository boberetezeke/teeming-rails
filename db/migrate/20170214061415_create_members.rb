class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.integer :databank_id

      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :company
      t.string :email
      t.string :first_name
      t.string :home_phone
      t.string :last_name
      t.string :middle_initial
      t.string :mobile_phone
      t.string :state
      t.string :status
      t.string :work_phone
      t.string :zip
      t.string :roster_status

      t.timestamps
    end

    add_index :members, :databank_id, unique: true
  end
end
