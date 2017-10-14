class AddRacesShowVoteTallies < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :show_vote_tallies, :boolean
    add_column :elections, :hide_on_dashboard, :boolean
  end
end
