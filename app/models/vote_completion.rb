class VoteCompletion < ApplicationRecord
  belongs_to :race
  belongs_to :user

  scope :for_race,      ->(race) { where(race: race) }
  scope :completed,     ->       { where(has_voted: true) }
end