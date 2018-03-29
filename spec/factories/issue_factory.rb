FactoryGirl.define do
  factory :issue do
    association :election
    association :chapter
    name "My Issue"

    after(:create) do |issue, evaluator|
      issue.questionnaire = FactoryGirl.create(:questionnaire)
    end
  end
end

