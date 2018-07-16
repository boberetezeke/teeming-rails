FactoryBot.define do
  factory :officer_assignment do
    association :user
    association :officer
  end
end

