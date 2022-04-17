FactoryBot.define do
  factory :officer do
    association :chapter

    transient do
      users { [] }
      roles { [] }
      start_date { nil }
      end_date { nil }
    end

    after(:create) do |officer, evaluator|
      officer.roles = evaluator.roles
      evaluator.users.each do |user|
        officer.officer_assignments << FactoryBot.create(:officer_assignment, user: user, start_date: evaluator.start_date, end_date: evaluator.end_date)
      end
    end
  end
end
