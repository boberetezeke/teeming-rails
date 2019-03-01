class AddUseUsername < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :use_username, :boolean
  end
end
