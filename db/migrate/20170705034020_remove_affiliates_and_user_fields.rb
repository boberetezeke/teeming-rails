class RemoveAffiliatesAndUserFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :phone_number
    remove_column :users, :address_1
    remove_column :users, :address_2
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :postal_code

    remove_index  :users, :affiliates_id
    remove_column :users, :affiliates_id

    drop_table :affiliates

    add_reference :members, :users
  end
end
