class AddStateToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :setup_state, :string
  end
end
