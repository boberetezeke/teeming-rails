class Election < ApplicationRecord
  belongs_to :chapter
  belongs_to :member_group

  has_many :races, dependent: :destroy
  accepts_nested_attributes_for :races

  has_many :issues, dependent: :destroy
  accepts_nested_attributes_for :issues

  has_many :vote_completions, dependent: :destroy

  ELECTION_TYPE_INTERNAL = 'internal'
  ELECTION_TYPE_EXTERNAL = 'external'

  scope :internal, ->{ where(election_type: ELECTION_TYPE_INTERNAL) }
  scope :external, ->{ where(election_type: ELECTION_TYPE_EXTERNAL) }
  scope :by_election_type, ->{ order('election_type asc') }

  attr_accessor :vote_date_str
  attr_accessor :vote_start_time_str, :vote_end_time_str

  validate :dates_and_times_are_valid

  def set_accessors
    self.vote_date_str = self.vote_date.strftime("%m/%d/%Y")          if self.vote_date
    self.vote_start_time_str = self.vote_start_time.strftime("%H:%M") if self.vote_start_time
    self.vote_end_time_str = self.vote_end_time.strftime("%H:%M")     if self.vote_end_time
  end

  def external?
    election_type == ELECTION_TYPE_EXTERNAL
  end

  def internal?
    election_type == ELECTION_TYPE_INTERNAL
  end

  def tally_votes
    if races.present?
      races.first.tally_votes
    else
      {}
    end
  end

  def write_tallies
    races.first.write_tallies if races.present?
  end

  def dates_and_times_are_valid
    valid_date = validate_date(:vote_date)
    valid_start_time = validate_time(:vote_start_time)
    valid_end_time = validate_time(:vote_end_time)

    if valid_date && valid_start_time && valid_end_time
      return if vote_start_time.blank? && vote_end_time.blank?
      if vote_start_time.present? && vote_end_time.present?
        if vote_start_time > vote_end_time
          errors.add(:base, "the start time should be before the end time")
        else
          self.vote_start_time = self.vote_start_time.change(year: vote_date.year, month: vote_date.month, day: vote_date.day)
          self.vote_end_time =   self.vote_end_time.change(  year: vote_date.year, month: vote_date.month, day: vote_date.day)
        end
      else
        errors.add(:base, "both start and end times (or neither) must be present")
      end
    end
  end

  def validate_time(time_sym)
    time_str_sym = "#{time_sym}_str"
    time_str = self.send(time_str_sym)
    return true if time_str.blank?

    m = /(\d+):(\d+)/.match(time_str)
    if m
      hour, minute = m.captures.map(&:to_i)
      if hour < 0 || hour >= 24
        errors.add(time_str_sym, "invalid hour '#{hour}'")
        return false
      end

      if minute < 0 || minute >= 60
        errors.add(time_str_sym, "invalid minute '#{minute}'")
        return false
      end

      self.send("#{time_sym}=", Time.zone.local(2017, 1, 1, hour, minute))
      return true
    else
      errors.add(time_str_sym, "invalid time")
      false
    end
  end

  def validate_date(date_sym)
    date_str_sym = "#{date_sym}_str"
    date_str = self.send(date_str_sym)
    return true if date_str.blank?

    m = /(\d+)\/(\d+)\/(\d+)/.match(date_str)
    if m
      month, day, year = m.captures.map(&:to_i)
      if month < 1 || month >= 12
        errors.add(date_sym_str, "invalid month '#{month}'")
        return false
      end

      if day < 0 || day >= 31
        errors.add(date_sym_str, "invalid day '#{day}'")
        return false
      end

      if year < 2017 || year > 2100
        errors.add(date_sym_str, "invalid year '#{year}'")
        return false
      end

      self.send("#{date_sym}=", Date.new(year, month, day))
      return true
    else
      errors.add(date_sym_str, "invalid date")
      false
    end
  end
end