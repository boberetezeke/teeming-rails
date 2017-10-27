class VoteCompletion < ApplicationRecord
  belongs_to :election
  belongs_to :user

  VOTE_COMPLETION_TYPE_ONLINE =         'online'
  VOTE_COMPLETION_TYPE_PAPER =          'paper'
  VOTE_COMPLETION_TYPE_DISQUALIFIED =   'disqualified'

  scope :for_election,        ->(election)  { where(election: election) }
  scope :completed,           ->            { where(has_voted: true) }
  scope :disqualifications,   ->            { where(vote_type: VOTE_COMPLETION_TYPE_DISQUALIFIED) }
end