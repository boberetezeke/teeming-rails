FactoryBot.define do
  factory :questionnaire_section do
    title { "My Great Questionnaire Section" }

    transient do
      skip_create_questions { false }
    end

    after(:create) do |questionnaire_section, evaluator|
      questionnaire_section.questions = [FactoryBot.create(:question)] unless evaluator.skip_create_questions
    end
  end
end
