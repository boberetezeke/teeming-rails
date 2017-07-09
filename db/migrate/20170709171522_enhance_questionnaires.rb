class EnhanceQuestionnaires < ActiveRecord::Migration[5.0]
  def change
    create_table :questionnaire_sections do |t|
      t.references :questionnaire
      t.string :title
      t.integer :order
    end

    create_table :choices do |t|
      t.references :question
      t.integer :order
      t.string :title
      t.string :value
    end

    add_column :questionnaires, :questionnairable_type, :string
    add_column :questionnaires, :questionnairable_id, :integer

    add_column :questions, :question_type, :string
    add_column :questions, :order, :integer
    add_reference :questions, :questionnaire_section
  end
end
