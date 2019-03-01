class AddShareOptions < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :share_email, :boolean
    add_column :users, :share_address, :boolean
    add_column :users, :share_phone, :boolean
    add_column :users, :share_name, :boolean
  end
end
