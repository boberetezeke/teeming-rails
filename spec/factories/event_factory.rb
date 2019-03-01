FactoryBot.define do
  factory :event do
    name "My Great Event"
    event_type Event::EVENT_TYPE_ONLINE_AND_OFFLINE
    location "Here"
    occurs_at 2.days.from_now

    trait :published do
      published_at Time.now
    end
  end
end

