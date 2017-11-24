class AddRaceAndElectionIdsToMessages < ActiveRecord::Migration[5.0]
  def change
    add_reference :messages, :election, index: true
    add_reference :messages, :race, index: true
  end
end
