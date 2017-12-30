FactoryGirl.define do
  factory :vote_completion do
    association :election
    association :user
  end
end