class AddElectionFrozen < ActiveRecord::Migration[5.0]
  def change
    add_column :elections, :is_frozen, :boolean
  end
end
