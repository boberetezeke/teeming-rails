class AddVoteTally < ActiveRecord::Migration[5.0]
  def change
    create_table :vote_tallies do |t|
      t.references :race, index: true
      t.references :candidacy, index: true
      t.integer :vote_count
    end
  end
end
