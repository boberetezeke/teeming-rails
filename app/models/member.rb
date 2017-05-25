class Member < ApplicationRecord
  validates :databank_id, presence: true, uniqueness: true

  scope :valid_email, -> {
    where(
      '(status != ? AND status != ? AND status != ? AND status != ?)',
      'invalid', 'bounce', 'block', 'unsubscribe'
    )
  }

  scope :current, -> {
    where('roster_status != ?', 'absent')
  }

  scope :active, -> {
    where(status: 'active').current
  }
end
