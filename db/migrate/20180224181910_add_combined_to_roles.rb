class AddCombinedToRoles < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :combined, :boolean
  end
end
