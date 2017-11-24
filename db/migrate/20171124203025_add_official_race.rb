class AddOfficialRace < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :is_official, :boolean
  end
end
