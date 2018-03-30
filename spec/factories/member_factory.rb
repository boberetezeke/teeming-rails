FactoryBot.define do
  factory :member do
    first_name "first_name"
    last_name  "last_name"

    trait :with_user do
      association :user
    end
  end
end
