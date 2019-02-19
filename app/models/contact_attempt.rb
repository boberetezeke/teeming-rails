class ContactAttempt < ApplicationRecord
  belongs_to :contactee
  belongs_to :contactor

  CONTACT_TYPE_PHONE_CALL   = 'phone_call_made'
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

  def contact_type_str
    CONTACT_TYPES_HASH.invert[contact_type]
  end

  def direction_type_str
    CONTACT_DIRECTIONS_HASH.invert[direction_type]
  end

  def result_type_str
    CONTACT_RESULTS_HASH.invert[result_type]
  end
end