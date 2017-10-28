class VoteCompletion < ApplicationRecord
  belongs_to :election
  belongs_to :user

  VOTE_COMPLETION_TYPE_ONLINE =         'online'
  VOTE_COMPLETION_TYPE_PAPER =          'paper'
  VOTE_COMPLETION_TYPE_DISQUALIFIED =   'disqualified'

  scope :for_election,        ->(election)  { where(election: election) }
  scope :can_vote,            ->            {
                                              where(VoteCompletion.arel_table[:vote_type].not_eq(VOTE_COMPLETION_TYPE_DISQUALIFIED).and(
                                                 VoteCompletion.arel_table[:has_voted].eq(nil)
                                              ))
                                            }
  scope :completed,           ->            { where(has_voted: true) }
  scope :disqualifications,   ->            { where(vote_type: VOTE_COMPLETION_TYPE_DISQUALIFIED) }
end