class AddAccountOwner < ActiveRecord::Migration[5.1]
  def change
    add_column :user_account_memberships, :role, :string
  end
end
