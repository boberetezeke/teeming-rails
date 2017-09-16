class VoteCompletion < ApplicationRecord
  belongs_to :race
  belongs_to :user

  VOTE_COMPLETION_TYPE_ONLINE =         'online'
  VOTE_COMPLETION_TYPE_PAPER =          'paper'
  VOTE_COMPLETION_TYPE_DISQUALIFIED =   'disqualified'

  scope :for_race,            ->(race) { where(race: race) }
  scope :completed,           ->       { where(has_voted: true) }
  scope :disqualifications,   ->       { where(vote_type: VOTE_COMPLETION_TYPE_DISQUALIFIED) }
end