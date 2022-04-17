FactoryBot.define do
  factory :vote_completion do
    association :election
    association :user
    vote_type { VoteCompletion::VOTE_COMPLETION_TYPE_ONLINE }

    trait :disqualified do
      vote_type { VoteCompletion::VOTE_COMPLETION_TYPE_DISQUALIFIED }
    end
  end
end