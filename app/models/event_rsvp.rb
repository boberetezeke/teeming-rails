class EventRsvp < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :rsvp_type, presence: true

  RSVP_TYPE_IN_PERSON = 'in-person'
  RSVP_TYPE_ONLINE =    'online'
  RSVP_TYPE_NO =        'no'

  RSVP_TYPES = {
      RSVP_TYPE_IN_PERSON => "In person",
      RSVP_TYPE_ONLINE    => "Online (we will be live streaming and have online voting)",
      RSVP_TYPE_NO        => "Will not attend"
  }
  RSVP_TYPES_DECLARATIVE = {
      RSVP_TYPE_IN_PERSON => "I will be there in person",
      RSVP_TYPE_ONLINE    => "I will participate online",
      RSVP_TYPE_NO        => "I will not attend"
  }
  RSVP_TYPES_FOR_FORM = RSVP_TYPES.invert
end