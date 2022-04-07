FactoryBot.define do
  factory :officer_assignment do
    association :user
    association :officer
    start_date { Date.new(2018,1,1) }
    end_date   { Date.new(2028,1,1) }
  end
end

