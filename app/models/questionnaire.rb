class Questionnaire < ApplicationRecord
  belongs_to :race
  has_many :questions
end