class AddCandidacyFields < ActiveRecord::Migration[5.0]
  def change
    add_column :candidacies, :party_affiliation, :string
    add_column :candidacies, :notes, :text
  end
end
