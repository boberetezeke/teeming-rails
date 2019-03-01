FactoryBot.define do
  factory :message_control do
    association :member
    control_type MessageControl::CONTROL_TYPE_NEUTRAL
    unsubscribe_type MessageControl::CONTROL_SUBSCRIPTION_TYPE_EMAIL
  end
end
