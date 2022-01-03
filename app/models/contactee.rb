class Contactee < ApplicationRecord
  belongs_to :account

  belongs_to :member
  belongs_to :contact_bank
  has_many   :contact_attempts

  accepts_nested_attributes_for :member

  scope :contacted,   ->{ where(arel_table[:contact_completed_at].eq(nil).not) }
  scope :uncontacted, ->{ where(arel_table[:contact_completed_at].eq(nil)) }
  scope :unattempted, ->{ where(arel_table[:contact_started_at].eq(nil)) }
  scope :attempted,   ->{ where(arel_table[:contact_started_at].eq(nil).not) }
  scope :contacted_by, ->(contactor){
    joins(:contact_attempts).where(ContactAttempt.arel_table[:contactor_id].eq(contactor.id)).distinct
  }

  def contacted_attempt
    contact_attempts.contacted.first
  end
end