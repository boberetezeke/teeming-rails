class ContactAttempt < ApplicationRecord
  belongs_to :contactee
  belongs_to :contactor

  validate   :attempted_at_date_and_time_is_valid
  after_save :update_contactee

  attr_accessor :attempted_at_date_str, :attempted_at_time_str

  CONTACT_TYPE_PHONE_CALL   = 'phone_call'
  CONTACT_TYPE_TEXT_MESSAGE = 'text_message'
  CONTACT_TYPE_EMAIL =        'email'
  CONTACT_TYPE_IN_PERSON =    'in_person'

  CONTACT_DIRECTION_OUT =     'out'
  CONTACT_DIRECTION_IN  =     'in'

  CONTACT_RESULT_LEFT_MESSAGE =    'left_message'
  CONTACT_RESULT_SENT_MESSAGE =    'sent_message'
  CONTACT_RESULT_LEFT_LITERATURE = 'left_literature'
  CONTACT_RESULT_NO_ANSWER =       'no_answer'
  CONTACT_RESULT_CONTACT_MADE =    'contact_made'

  CONTACT_TYPES_HASH = {
    "Phone Call" =>             CONTACT_TYPE_PHONE_CALL,
    "Text Message" =>           CONTACT_TYPE_TEXT_MESSAGE,
    "Email" =>                  CONTACT_TYPE_EMAIL,
    "In Person Conversation" => CONTACT_TYPE_IN_PERSON
  }

  CONTACT_DIRECTIONS_HASH = {
    "Inbound" => CONTACT_DIRECTION_IN,
    "Outbound" => CONTACT_DIRECTION_OUT
  }

  CONTACT_RESULTS_HASH = {
    "Sent Message" => CONTACT_RESULT_SENT_MESSAGE,
    "Left Message" => CONTACT_RESULT_LEFT_MESSAGE,
    "No Answer" =>    CONTACT_RESULT_NO_ANSWER,
    "Contact Made" => CONTACT_RESULT_CONTACT_MADE
  }

  def set_accessors
    self.attempted_at_date_str = self.attempted_at.strftime("%m/%d/%Y")
    self.attempted_at_time_str = self.attempted_at.strftime("%I:%M%P")
  end

  def contact_type_str
    CONTACT_TYPES_HASH.invert[contact_type]
  end

  def direction_type_str
    CONTACT_DIRECTIONS_HASH.invert[direction_type]
  end

  def result_type_str
    CONTACT_RESULTS_HASH.invert[result_type]
  end

  private

  def attempted_at_date_and_time_is_valid
    date = nil
    time = nil

    valid_date = validate_date(:attempted_at_date) { |d|
      date = d
    }
    valid_time = validate_time(:attempted_at_time) { |t|
      time = t
    }
    if valid_date && valid_time
      if date && time
        self.attempted_at = Time.zone.local(date.year, date.month, date.day, time.hour, time.min)
      else
        errors.add(:base, "must specify a date and a time")
      end
    end
  end

  def update_contactee
    if contactee.contact_started_at.nil?
      contactee.contact_started_at = attempted_at
    end
    if contactee.contact_completed_at.nil? && result_type == ContactAttempt::CONTACT_RESULT_CONTACT_MADE
      contactee.contact_completed_at = attempted_at
    end
    contactee.save if contactee.changed?
  end
end