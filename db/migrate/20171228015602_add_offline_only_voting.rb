class AddOfflineOnlyVoting < ActiveRecord::Migration[5.0]
  def change
    add_column :vote_completions, :ballot_identifier, :string
    add_column :elections, :election_method, :string
  end
end
