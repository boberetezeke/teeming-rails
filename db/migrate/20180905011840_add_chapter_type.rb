class AddChapterType < ActiveRecord::Migration[5.1]
  def change
    add_column :chapters, :chapter_type, :string
  end
end
