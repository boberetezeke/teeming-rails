class Member < ApplicationRecord
  has_many :survey_answers
  validates :databank_id, presence: true, uniqueness: true

  scope :valid_email, -> {
    where('status != ? OR status IS NULL', 'invalid')
  }

  scope :active, -> { where(status: 'active') }
end
