class Member < ApplicationRecord
  has_many :survey_answers
  validates :databank_id, presence: true, uniqueness: true

  scope :valid_email, -> {
    where('(status != ? AND status != ?) OR status IS NULL',
          'invalid', 'bounce')
  }

  scope :active, -> {
    where(status: 'active').where('roster_status != ?', 'absent')
  }
end
