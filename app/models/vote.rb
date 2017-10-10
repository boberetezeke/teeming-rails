class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :candidacy
  belongs_to :race

  scope :for_race, ->(race){ where(race: race) }
  scope :by_user,  ->{ order("user_id asc") }
end