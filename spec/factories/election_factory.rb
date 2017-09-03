FactoryGirl.define do
  factory :election do
    election_type Election::ELECTION_TYPE_INTERNAL

    trait :internal do
      election_type Election::ELECTION_TYPE_INTERNAL
    end
    trait :external do
      election_type Election::ELECTION_TYPE_EXTERNAL
    end
  end
end
