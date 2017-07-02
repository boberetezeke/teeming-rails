class Race < ApplicationRecord
  belongs_to :election
  has_many :candidacies
  has_one  :questionnaire
end