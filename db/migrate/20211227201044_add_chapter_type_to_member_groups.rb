class AddChapterTypeToMemberGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :member_groups, :chapter_type, :string
  end
end
