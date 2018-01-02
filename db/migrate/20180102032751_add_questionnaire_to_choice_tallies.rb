class AddQuestionnaireToChoiceTallies < ActiveRecord::Migration[5.0]
  def change
    add_reference :choice_tallies, :questionnaire, index: true
  end
end
