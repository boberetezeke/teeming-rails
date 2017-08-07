class AddElectionTypeToElections < ActiveRecord::Migration[5.0]
  def change
    add_column :elections, :election_type, :string
  end
end
