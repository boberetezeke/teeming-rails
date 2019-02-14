class AddContactBanks < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_banks do |t|
      t.string :name
      t.text   :script
      t.text   :notes
      t.bigint :owner_id

      t.timestamps
    end
    add_index :contact_banks, :owner_id

    create_table :contactors do |t|
      t.references :contact_bank, index: true
      t.references :user,         index: true
    end

    create_table :contactees do |t|
      t.references :contact_bank, index: true
      t.references :member,       index: true
    end

    create_table :contact_attempts do |t|
      t.references :contact_bank, index: true
      t.references :member,       index: true
      t.string    :contact_type
      t.text      :notes
      t.timestamps
    end
  end
end
