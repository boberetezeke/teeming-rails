class Candidacy < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :race

  accepts_nested_attributes_for :answers
end