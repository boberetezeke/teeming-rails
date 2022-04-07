FactoryBot.define do
  factory :race do
    name        { 'race' }
    association :election
    level_of_government { Race::LEVEL_OF_GOVERNMENT_TYPE_GOVERNOR }
    locale { 'Roseville' }
    filing_deadline_date          { Date.new(2017,3,10) }
    candidates_announcement_date  { Date.new(2017,3,20) }
  end
end
