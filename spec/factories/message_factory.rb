FactoryBot.define do
  factory :message do
    subject 'message subject'
    body    'message body'

    trait :sent do
      sent_at Time.now
      member_group MemberGroup.first
    end
  end
end
