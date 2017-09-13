class AddVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.references :user, index: true
      t.references :candidacy, index: true
      t.references :race, index: true
    end

    create_table :vote_completions do |t|
      t.references :user, index: true
      t.references :race, index: true
      t.boolean :has_voted
      t.string  :token, index: true
    end
  end
end
