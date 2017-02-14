class CreateSurveyAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :survey_answers do |t|
      t.json :contents
      t.belongs_to :member, foreign_key: true
      t.belongs_to :survey, foreign_key: true

      t.timestamps
    end

    add_index :survey_answers, [:member_id, :survey_id], unique: true
  end
end
