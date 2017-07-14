class AddElections < ActiveRecord::Migration[5.0]
  def change
    create_table :chapters do |t|
      t.boolean :is_state_wide
      t.string  :name
      t.text    :description
    end

    create_table :roles do |t|
      t.references  :chapter, foreign_key: true
      t.string      :name
      t.text        :description
    end

    create_table :elections do |t|
      t.references  :chapter, foreign_key: true
      t.string :name
      t.text   :description
    end

    create_table :races do |t|
      t.string :name
      t.references :election, foreign_key: true
      t.references :role, foreign_key: true
    end

    create_table :candidacies do |t|
      t.references :race, foreign_key: true
      t.references :user, foreign_key: true
    end

    create_table :questionnaires do |t|
      t.string :name
    end

    create_table :questions do |t|
      t.references :questionnaire, foreign_key: true
    end

    create_table :answers do |t|
      t.references :question, foreign_key: true
      t.references :candidacy, foreign_key: true
    end

    create_table :role_assignments do |t|
      t.references  :user, foreign_key: true
      t.references  :role, foreign_key: true
      t.references  :chapter, foreign_key: true
    end

    create_table :candidate_assignments do |t|
      t.references  :user, foreign_key: true
      t.references  :role, foreign_key: true
      t.references  :answers, foreign_key: true
    end
  end
end
