FactoryGirl.define do
  factory :election do
    vote_date Date.new(2017, 3, 30)

    election_type Election::ELECTION_TYPE_INTERNAL

    trait :internal do
      election_type Election::ELECTION_TYPE_INTERNAL
    end
    trait :external do
      election_type Election::ELECTION_TYPE_EXTERNAL
    end
  end
end
