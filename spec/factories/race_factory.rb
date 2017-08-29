FactoryGirl.define do
  factory :race do
    name        'race'
    association :election
  end
end
