class AddDisqualificationReason < ActiveRecord::Migration[5.0]
  def change
    add_column :vote_completions, :disqualification_message, :string
  end
end
