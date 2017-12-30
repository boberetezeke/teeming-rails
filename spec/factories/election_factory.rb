FactoryGirl.define do
  factory :election do
    vote_date Date.new(2017, 3, 30)
    name "My great election"

    election_type Election::ELECTION_TYPE_INTERNAL

    trait :internal do
      election_type Election::ELECTION_TYPE_INTERNAL
    end
    trait :external do
      election_type Election::ELECTION_TYPE_EXTERNAL
    end

    trait :online_only do
      election_method Election::ELECTION_METHOD_ONLINE_ONLY
    end
    trait :online_and_offline do
      election_method Election::ELECTION_METHOD_ONLINE_AND_OFFLINE
    end
    trait :offline_only do
      election_method Election::ELECTION_METHOD_OFFLINE_ONLY
    end
  end
end
