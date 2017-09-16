class AddRaceVotingTimes < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :vote_start_time, :datetime
    add_column :races, :vote_end_time, :datetime
  end
end
