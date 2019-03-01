class AddNewWithUser < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :added_with_new_user, :boolean
  end
end
