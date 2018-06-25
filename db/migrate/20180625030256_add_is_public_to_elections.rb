class AddIsPublicToElections < ActiveRecord::Migration[5.1]
  def change
    add_column :elections, :is_public, :boolean
  end
end
