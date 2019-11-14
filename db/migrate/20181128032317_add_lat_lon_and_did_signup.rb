class AddLatLonAndDidSignup < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :latitude, :float
    add_column :members, :longitude, :float
    add_column :members, :is_non_member, :boolean
  end
end
