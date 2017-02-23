class Member < ApplicationRecord
  has_many :survey_answers
  validates :databank_id, presence: true, uniqueness: true

  scope :valid_email, -> {
    where(
      '(status != ? AND status != ? AND status != ?)',
      'invalid', 'bounce', 'block'
    )
  }

  scope :current, -> {
    where('roster_status != ?', 'absent')
  }

  scope :active, -> {
    where(status: 'active').current
  }
end
