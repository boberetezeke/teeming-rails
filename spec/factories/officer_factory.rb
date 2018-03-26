FactoryGirl.define do
  factory :officer do
    association :chapter

    transient do
      users []
      roles []
    end

    after(:create) do |officer, evaluator|
      officer.roles = evaluator.roles
      officer.users = evaluator.users
    end
  end
end
