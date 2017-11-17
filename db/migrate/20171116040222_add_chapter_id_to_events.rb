class AddChapterIdToEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :chapter, index: true
  end
end
