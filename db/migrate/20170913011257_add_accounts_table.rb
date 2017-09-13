class AddAccountsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string  :name
      t.boolean :registration_disabled
      t.string  :registration_disabled_reason
    end
  end
end
