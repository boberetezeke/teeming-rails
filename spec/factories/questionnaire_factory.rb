FactoryGirl.define do
  factory :questionnaire do
    after(:create) do |questionnaire, evaluator|
      questionnaire.questionnaire_sections = [FactoryGirl.create(:questionnaire_section)]
    end
  end
end
