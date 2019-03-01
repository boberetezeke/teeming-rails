FactoryBot.define do
  factory :message_recipient do
    association :member
    association :message
  end
end
