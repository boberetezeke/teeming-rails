FactoryGirl.define do
  factory :questionnaire_section do
    title "My Great Questionnaire Section"

    transient do
      skip_create_questions false
    end

    after(:create) do |questionnaire_section, evaluator|
      questionnaire_section.questions = [FactoryGirl.create(:question)] unless evaluator.skip_create_questions
    end
  end
end
