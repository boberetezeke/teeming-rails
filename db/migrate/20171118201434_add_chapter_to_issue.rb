class AddChapterToIssue < ActiveRecord::Migration[5.0]
  def change
    add_reference :issues, :chapter, index: true
  end
end
