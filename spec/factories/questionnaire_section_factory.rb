FactoryGirl.define do
  factory :questionnaire_section do
    title "My Great Questionnaire Section"
    after(:create) do |questionnaire_section, evaluator|
      questionnaire_section.questions = [FactoryGirl.create(:question)]
    end
  end
end
