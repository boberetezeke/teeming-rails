class Event < ApplicationRecord
  has_many :event_rsvps, dependent: :destroy
  has_many :messages, dependent: :destroy

  belongs_to :chapter
  belongs_to :member_group

  EVENT_TYPE_OFFLINE_ONLY = 'offline_only'
  EVENT_TYPE_ONLINE_ONLY = 'online_only'
  EVENT_TYPE_ONLINE_AND_OFFLINE = 'online_and_offline'

  EVENT_TYPES_HASH = {
    'Online only' => EVENT_TYPE_ONLINE_ONLY,
    'Offline only' => EVENT_TYPE_OFFLINE_ONLY,
    'Online and offline' => EVENT_TYPE_ONLINE_AND_OFFLINE
  }

  attr_accessor :occurs_at_date_str, :occurs_at_time_str

  scope :future, ->{ where(Event.arel_table[:occurs_at].gt(Time.zone.now)) }
  scope :published, ->{ where(Event.arel_table[:published_at].not_eq(nil)) }

  validates :name, presence: true
  validates :event_type, presence: true

  validate :occurs_at_date_and_time_is_valid

  def set_accessors
    self.occurs_at_date_str = self.occurs_at.strftime("%m/%d/%Y")     if self.occurs_at
    self.occurs_at_time_str = self.occurs_at.strftime("%I:%M%P")        if self.occurs_at
  end

  def published?
    self.published_at.present?
  end

  def online_only?
    event_type == EVENT_TYPE_ONLINE_ONLY
  end

  def offline_only?
    event_type == EVENT_TYPE_OFFLINE_ONLY
  end

  def publish
    update(published_at: Time.now)
  end

  def unpublish
    update(published_at: nil)
  end

  def event_type_str
    EVENT_TYPES_HASH.invert[event_type]
  end

  def occurs_at_date_and_time_is_valid
    date = nil
    time = nil

    valid_date = validate_date(:occurs_at_date) { |d|
      date = d
    }
    valid_time = validate_time(:occurs_at_time) { |t|
      time = t
    }
    if valid_date && valid_time
      if date && !time
        self.occurs_at = Time.zone.local(date.year, date.month, date.day, 00, 00)
      elsif !date && time
        errors.add(:base, "must specify a date with a time")
      elsif date && time
        self.occurs_at = Time.zone.local(date.year, date.month, date.day, time.hour, time.min)
      end
    end
  end
end