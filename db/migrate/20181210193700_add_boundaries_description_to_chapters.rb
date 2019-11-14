class AddBoundariesDescriptionToChapters < ActiveRecord::Migration[5.1]
  def change
    add_column :chapters, :boundaries_description_yml, :text
  end
end
