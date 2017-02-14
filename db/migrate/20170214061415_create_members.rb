class CreateMembers < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      CREATE TYPE member_status AS ENUM
      ('active', 'duplicate', 'invalid', 'problem');
    SQL

    create_table :members do |t|
      t.integer :databank_id
      t.column :status, :member_status, default: 'active'

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
      t.string :work_phone
      t.string :zip

      t.timestamps
    end

    add_index :members, :databank_id, unique: true
  end

  def down
    drop_table :members

    execute <<-SQL
      DROP TYPE member_status;
    SQL
  end
end
