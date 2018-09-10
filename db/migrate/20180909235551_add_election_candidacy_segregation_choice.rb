class AddElectionCandidacySegregationChoice < ActiveRecord::Migration[5.1]
  def change
    add_column :races, :election_candidacy_segregation_choice_id, :integer
  end
end
