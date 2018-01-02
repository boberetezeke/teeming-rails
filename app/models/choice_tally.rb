class ChoiceTally < ApplicationRecord
  belongs_to  :questionnaire
  belongs_to  :question
  has_many    :choice_tally_answers

  scope :by_count,  ->        { order("count desc") }
  scope :for_round, ->(round) { where(round: round) }

  def choice
    question.choices[value.to_i - 1]
  end
end