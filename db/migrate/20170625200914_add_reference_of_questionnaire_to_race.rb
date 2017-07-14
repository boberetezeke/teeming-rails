class AddReferenceOfQuestionnaireToRace < ActiveRecord::Migration[5.0]
  def change
    add_reference :questionnaires, :race, foreign_key: true
  end
end
