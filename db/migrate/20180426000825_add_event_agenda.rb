class AddEventAgenda < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :agenda, :text
  end
end
