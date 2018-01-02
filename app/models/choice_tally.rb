class ChoiceTally < ApplicationRecord
  belongs_to  :question
  has_many    :choice_tally_answers
end