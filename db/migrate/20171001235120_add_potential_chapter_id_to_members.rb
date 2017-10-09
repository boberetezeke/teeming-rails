class AddPotentialChapterIdToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :potential_chapter_id, :integer
    add_index  :members, :potential_chapter_id
  end
end
