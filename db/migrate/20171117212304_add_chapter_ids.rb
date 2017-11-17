class AddChapterIds < ActiveRecord::Migration[5.0]
  def change
    add_reference :races, :chapter, index: true
    add_reference :messages, :chapter, index: true
  end
end
