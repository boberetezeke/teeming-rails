class OfficerAssignment < ApplicationRecord
  belongs_to :officer
  belongs_to :user

  attr_accessor :start_date_str, :end_date_str

  scope :active,    ->{ where(arel_table[:end_date].eq(nil).or(arel_table[:end_date].gteq(Time.now))) }
  scope :inactive,  ->{ where(arel_table[:end_date].lt(Time.now))}

  START_REASONS_HASH = {
    "Election by membership" => 'election-by-membership',
    "Appointment by board"   => 'appointment-by-board'
  }

  END_REASONS_HASH = {
      "End of term" => 'end-of-term',
      "Resignation"   => 'resignation',
      "Termination" => 'termination'
  }

  validate :dates_and_times_are_valid

  def set_accessors
    self.start_date_str = self.start_date.strftime("%m/%d/%Y")      if self.start_date
    self.end_date_str = self.end_date.strftime("%m/%d/%Y")          if self.end_date
  end

  def dates_and_times_are_valid
    valid_start_date = validate_date(:start_date)
    valid_end_date = validate_date(:end_date)

    if valid_start_date && valid_end_date
      return if start_date.blank? && end_date.blank?
      if start_date.present? && end_date.present?
        if start_date > end_date
          errors.add(:base, "the start date should be before the end date")
        end
      else
        errors.add(:base, "both start and end dates (or neither) must be present")
      end
    end
  end

  def active?
    start_date &&
        end_date &&
        Time.zone.now >= start_date &&
        Time.zone.now <= end_date
  end
end