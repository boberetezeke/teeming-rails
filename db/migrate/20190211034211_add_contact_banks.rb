class AddContactBanks < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_banks do |t|
      t.string      :name
      t.text        :script
      t.text        :notes
      t.bigint      :owner_id
      t.references  :chapter, index: true

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
      t.datetime   :contact_completed_at
    end

    create_table :contact_attempts do |t|
      t.references :contactor,   index: true
      t.references :contactee,   index: true
      t.string    :contact_type
      t.string    :direction_type
      t.string    :result_type
      t.text      :notes
      t.datetime  :contact_completed_at

      t.timestamps
    end
  end
end
