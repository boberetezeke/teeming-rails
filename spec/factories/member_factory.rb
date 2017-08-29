FactoryGirl.define do
  factory :member do

    trait :with_user do
      association :user
    end
  end
end
