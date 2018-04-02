FactoryBot.define do
  factory :event do
    name "My Great Event"
    location "Here"
    occurs_at 2.days.from_now

    trait :published do
      published_at Time.now
    end
  end
end

