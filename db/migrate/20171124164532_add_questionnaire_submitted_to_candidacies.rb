class AddQuestionnaireSubmittedToCandidacies < ActiveRecord::Migration[5.0]
  def change
    add_column :candidacies, :questionnaire_submitted_at, :datetime
  end
end
