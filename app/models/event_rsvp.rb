class EventRsvp < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :rsvp_type, presence: true, unless: :during_initialization

  attr_accessor :during_initialization

  RSVP_TYPE_IN_PERSON_AND_VOLUNTEER = 'in-person-volunteer'
  RSVP_TYPE_IN_PERSON = 'in-person'
  RSVP_TYPE_ONLINE =    'online'
  RSVP_TYPE_NO =        'no'

  RSVP_TYPES = {
      RSVP_TYPE_IN_PERSON_AND_VOLUNTEER =>  "In person and want to help out",
      RSVP_TYPE_IN_PERSON =>                "In person",
      RSVP_TYPE_ONLINE    =>                "Online (we will be live streaming and possibly have online voting)",
      RSVP_TYPE_NO        =>                "Will not attend"
  }
  RSVP_TYPES_DECLARATIVE = {
      RSVP_TYPE_IN_PERSON_AND_VOLUNTEER =>  "I will be there in person and want to help out",
      RSVP_TYPE_IN_PERSON =>                "I will be there in person",
      RSVP_TYPE_ONLINE    =>                "I will participate online",
      RSVP_TYPE_NO        =>                "I will not attend"
  }

  scope :for_user,  ->(user) { where(user: user) }
  scope :in_person, ->{ where(rsvp_type: [RSVP_TYPE_IN_PERSON, RSVP_TYPE_IN_PERSON_AND_VOLUNTEER]) }
  scope :online,    ->{ where(rsvp_type: RSVP_TYPE_ONLINE) }
  scope :no,        ->{ where(rsvp_type: RSVP_TYPE_NO) }

  def rsvp_types_available
    if event.online_only?
      Hash[EventRsvp::RSVP_TYPES.to_a.reject{|rsvp_type, message| rsvp_type == RSVP_TYPE_IN_PERSON }].invert
    elsif event.offline_only?
      Hash[EventRsvp::RSVP_TYPES.to_a.reject{|rsvp_type, message| rsvp_type == RSVP_TYPE_ONLINE }].invert
    else
      EventRsvp::RSVP_TYPES.invert
    end
  end
end