class AddSelectedAccountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :selected_account_id, :integer
    add_index :users, :selected_account_id
  end
end
