class AddFixedRoleToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :fixed_role, :string
  end
end
