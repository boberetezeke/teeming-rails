class Contactee < ApplicationRecord
  belongs_to :member
  belongs_to :contact_bank
  has_many   :contact_attempts

  scope :contacted, ->{ where(arel_table[:contact_completed_at].eq(nil).not) }
end