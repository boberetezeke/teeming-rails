class AddEventSignIns < ActiveRecord::Migration[5.0]
  def change
    create_table :event_sign_ins do |t|
      t.references :event, index: true
      t.references :memeber, index: true
      t.string     :sign_in_type
    end
  end
end
