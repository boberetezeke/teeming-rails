class AddCandidacyEmail < ActiveRecord::Migration[5.0]
  def change
    add_column :candidacies, :email, :string
  end
end
