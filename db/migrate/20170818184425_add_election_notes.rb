class AddElectionNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :notes, :text
  end
end
