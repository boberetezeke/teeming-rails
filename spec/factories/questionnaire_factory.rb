FactoryBot.define do
  factory :questionnaire do
    transient do
      skip_create_sections { false }
    end

    after(:create) do |questionnaire, evaluator|
      questionnaire.questionnaire_sections = [FactoryBot.create(:questionnaire_section)] unless evaluator.skip_create_sections
    end
  end
end
