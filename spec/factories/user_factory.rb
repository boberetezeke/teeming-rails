FactoryGirl.define do
  factory :user do
    sequence(:email) {|s| "a@b-#{s}.com" }

    password                'asdfasdf'
    password_confirmation   'asdfasdf'

    confirmed_at            Time.now
    association             :role
  end
end
