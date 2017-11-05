class AddShowVoteTalliesToElection < ActiveRecord::Migration[5.0]
  def change
    add_column :elections, :show_vote_tallies, :boolean
  end
end
