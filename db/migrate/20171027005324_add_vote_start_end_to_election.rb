class AddVoteStartEndToElection < ActiveRecord::Migration[5.0]
  def change
    add_column :elections, :vote_start_time, :datetime
    add_column :elections, :vote_end_time, :datetime
    add_column :vote_completions, :election_id, :integer
    add_index  :vote_completions, :election_id
  end
end
