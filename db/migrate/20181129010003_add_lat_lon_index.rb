class AddLatLonIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :members, [:latitude, :longitude]
  end
end
