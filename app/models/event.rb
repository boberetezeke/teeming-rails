class Event < ApplicationRecord
  has_many :event_rsvps

  scope :future, ->{ where(Event.arel_table[:occurs_at].gt(Time.zone.now)) }
end