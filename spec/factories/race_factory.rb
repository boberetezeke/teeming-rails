FactoryGirl.define do
  factory :race do
    name        'race'
    association :election
    level_of_government Race::LEVEL_OF_GOVERNMENT_TYPE_GOVERNOR
    locale 'Roseville'
  end
end
