class AddAnswerVoteTallies < ActiveRecord::Migration[5.0]
  def change
    create_table :choice_tallies do |t|
      t.references :question, index: true
      t.string  :value
      t.integer :count
      t.integer :round
    end

    create_table :choice_tally_answers do |t|
      t.references :choice_tally, index: true
      t.references :answer, index: true
    end
  end
end
