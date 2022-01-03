class AddChapterAttrsToMemberGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :member_groups, :description, :string
    add_column :member_groups, :visibility, :string
    add_column :member_groups, :boundaries_description_yml, :text
  end
end
