FactoryBot.define do
  factory :when_to_meet do
    name { "name" }
    start_date { Date.today }
    end_date { Date.today+1 }
    starting_hour { 9 }
    ending_hour { 20 }
    users { [] }
    time_slots { {} }
  end
end

