class AddTimestampsAndWhoModified < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :created_at, :datetime
    add_column :races, :updated_at, :datetime
    add_reference :races, :created_by_user
    add_reference :races, :updated_by_user
    add_reference :candidacies, :created_by_user
    add_reference :candidacies, :updated_by_user
    add_column :candidacies, :created_at, :datetime
    add_column :candidacies, :updated_at, :datetime
  end
end
