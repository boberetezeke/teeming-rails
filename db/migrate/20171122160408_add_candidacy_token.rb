class AddCandidacyToken < ActiveRecord::Migration[5.0]
  def change
    add_column :candidacies, :token, :string
  end
end
