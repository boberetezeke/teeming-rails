class ChoiceTally < ApplicationRecord
  belongs_to :account

  belongs_to  :questionnaire
  belongs_to  :question
  has_many    :choice_tally_answers

  scope :by_count,  ->        { order("count desc") }
  scope :for_round, ->(round) { where(round: round) }

  def choice_title
    if value.nil?
      "Exhausted"
    else
      question.choices[value.to_i - 1].title
    end
  end
end