class AddNameToCandidacies < ActiveRecord::Migration[5.0]
  def change
    add_column :candidacies, :name, :string
  end
end
