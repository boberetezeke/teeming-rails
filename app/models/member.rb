class Member < ApplicationRecord
  has_many :survey_answers
  validates :databank_id, presence: true, uniqueness: true
end
