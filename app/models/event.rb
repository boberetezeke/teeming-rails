class Event < ApplicationRecord
  has_many :event_rsvps

  scope :future, ->{ where(Event.arel_table[:occurs_at].lt(Time.zone.now)) }
end