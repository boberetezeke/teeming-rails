class AddVoteType < ActiveRecord::Migration[5.0]
  def change
    add_column :vote_completions, :vote_type, :string
  end
end
