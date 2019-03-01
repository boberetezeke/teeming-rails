FactoryBot.define do
  factory :user do
    sequence(:email) {|s| "a@b-#{s}.com" }

    password                'asdfasdf'
    password_confirmation   'asdfasdf'

    confirmed_at            Time.now
    association             :role

    transient do
      chapter nil
    end

    after(:create) do |user, evaluator|
      user.member = FactoryBot.create(:member, email: user.email, chapter: evaluator.chapter)
    end
  end
end
