class VoteTally < ApplicationRecord
  belongs_to :account

  belongs_to :race
  belongs_to :candidacy
end