class VoteTally < ApplicationRecord
  belongs_to :race
  belongs_to :candidacy
end