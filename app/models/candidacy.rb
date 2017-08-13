class Candidacy < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :race, touch: true

  accepts_nested_attributes_for :answers

end