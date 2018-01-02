class ChoiceTallyAnswer < ApplicationRecord
  belongs_to :choice_tally
  belongs_to :answer
end