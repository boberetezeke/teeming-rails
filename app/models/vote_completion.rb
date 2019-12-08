class VoteCompletion < ApplicationRecord
  belongs_to :account

  belongs_to :election
  accepts_nested_attributes_for :election

  has_many :answers, as: :answerable

  accepts_nested_attributes_for :answers

  belongs_to :user

  VOTE_COMPLETION_TYPE_ONLINE =         'online'
  VOTE_COMPLETION_TYPE_PAPER =          'paper'
  VOTE_COMPLETION_TYPE_DISQUALIFIED =   'disqualified'

  VOTE_TYPE_HASH = {
     "Paper" => VOTE_COMPLETION_TYPE_PAPER,
     "Online" => VOTE_COMPLETION_TYPE_ONLINE,
     "Disqualified" => VOTE_COMPLETION_TYPE_DISQUALIFIED
  }

  scope :for_election,        ->(election)  { where(election: election) }
  scope :can_vote,            ->            {
                                              where(VoteCompletion.arel_table[:vote_type].not_eq(VOTE_COMPLETION_TYPE_DISQUALIFIED).and(
                                                 VoteCompletion.arel_table[:has_voted].eq(nil)
                                              ))
                                            }
  scope :completed,             ->          { where(has_voted: true) }
  scope :disqualifications,     ->          { where(vote_type: VOTE_COMPLETION_TYPE_DISQUALIFIED) }
  scope :not_disqualifications, ->          { where(VoteCompletion.arel_table[:vote_type].not_eq(VOTE_COMPLETION_TYPE_DISQUALIFIED)) }

  scope :by_id, ->{ order('id asc') }
  scope :by_reverse_id, ->{ order('id desc') }

  def next_id_for_election(election)
    election.vote_completions.completed.where(VoteCompletion.arel_table[:id].gt(self.id)).by_id.first
  end

  def prev_id_for_election(election)
    election.vote_completions.completed.where(VoteCompletion.arel_table[:id].lt(self.id)).by_reverse_id.first
  end

  def disqualified?
    vote_type == VOTE_COMPLETION_TYPE_DISQUALIFIED
  end

  def available_to_vote?
    !has_voted
  end
end
