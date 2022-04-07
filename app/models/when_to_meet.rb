class WhenToMeet < ApplicationRecord
  class User
    include ActiveModel::Validations

    attr_accessor :name, :email, :is_creator
    attr_reader :id

    validates :name, presence: true
    validates :email, presence: true, format: /\A[^@]+@[^@]+\z/

    def initialize(name:, email:, is_creator:, id: nil)
      @name = name
      @email = email.downcase
      @is_creator = is_creator
      @id = id
    end

    def save(users)
      @id = generate_id(users)
    end

    def update(name: nil, email: nil)
      @name = name if name
      @email = email if email
    end

    def persisted?
      @id.present?
    end

    def generate_id(users)
      m = /^([^@]*).*/.match(@email)
      if m
        id = m[1].gsub(/\./, "_")
        orig_id = id
        next_num = 2
        while true
           break unless users.map(&:id).include?(id)
           id = orig_id + next_num.to_s
           next_num += 1
        end
      end

      id
    end
  end

  attr_accessor :start_date_str, :end_date_str, :starting_hour_str, :ending_hour_str
  attr_accessor :editing_content

  validates :name, presence: true
  validate :valid_start_and_end_dates, unless: ->{ editing_content }
  validate :valid_start_and_end_hours, unless: ->{ editing_content }

  after_initialize :set_strs
  before_create :create_slug

  serialize :users
  serialize :time_slots

  def find_user_by_id(id)
    return nil if id.nil?
    users.to_a.select{|user| user.id == id}.first
  end

  def find_user_by_email(email)
    users.to_a.select{|user| user.email == email.downcase}.first
  end

  # def new_user(user_name, user_email, is_creator)
  #   User.new(name: user_name, email: user_email, id_for_email(user_email), is_creator)
  # end

  def add_user(user)
    self.users ||= []
    self.users << user
    user
  end

  def set_time_slot_from_checks_and_user(checks, user)
    self.time_slots ||= {}
    self.time_slots.each do |check, emails|
      if emails.include?(user.email)
        new_emails = emails.reject{|email| email == user.email}
        if new_emails.present?
          self.time_slots[check] = new_emails
        else
          self.time_slots.delete(check)
        end
      end
    end
    checks.each do |check, _|
      users_for_check = self.time_slots[check] || []
      unless users_for_check.include?(user.email)
        self.time_slots[check] = users_for_check + [user.email]
      end
    end
  end

  def set_strs
    unless self.start_date_str
      self.start_date_str = self.start_date ? self.start_date.strftime("%m/%d/%Y") : nil
    end
    unless self.end_date_str
      self.end_date_str = self.end_date ? self.end_date.strftime("%m/%d/%Y") : nil
    end

    unless self.starting_hour_str
      self.starting_hour_str = self.starting_hour ? self.starting_hour.to_s : nil
    end
    unless self.ending_hour_str
      self.ending_hour_str = self.ending_hour ? self.ending_hour.to_s : nil
    end
  end

  def valid_start_and_end_hours
    return true if starting_hour_str.nil? && ending_hour_str.nil?

    valid_starting_hour = true
    valid_ending_hour = true
    m = /^(\d+)$/.match(starting_hour_str)
    if m  && starting_hour_str.to_i >= 1 && starting_hour_str.to_i <= 23
      self.starting_hour = starting_hour_str.to_i
    else
      valid_starting_hour = false
      errors.add(:starting_hour_str, "is not a valid hour")
    end

    m = /^(\d+)$/.match(ending_hour_str)
    if m && ending_hour_str.to_i >= 1 && ending_hour_str.to_i <= 23
      self.ending_hour = ending_hour_str.to_i
    else
      errors.add(:ending_hour_str, "is not a valid hour")
      valid_ending_hour = false
    end

    if valid_starting_hour && valid_ending_hour
      if self.starting_hour > self.ending_hour
        errors.add(:base, "starting hour is not less than the ending hour")
      end
    end
  end

  def valid_start_and_end_dates
    return true if self.start_date_str.nil? && self.end_date_str.nil?

    valid_start_date = validate_date(:start_date) { |d|
      self.start_date = d
    }
    valid_end_date = validate_date(:end_date) { |d|
      self.end_date = d
    }

    if !valid_start_date
      errors.add(:start_date_str, "is invalid")
    end
    if !valid_end_date
      errors.add(:end_date_str, "is invalid")
    end
    if valid_start_date && valid_end_date
      if self.start_date > self.end_date
        errors.add(:base, "start date is not less than the end date")
      end
    end
  end

  def valid_date(sym)
    date_str = send(sym)
    date = Date.parse(date_str)
  end

  def create_slug
    slug_root = name.split(/\s+/).map(&:downcase).join("-")
    self.slug = slug_root
    while true
      break unless self.class.find_by_slug(self.slug)
      self.slug = slug_root + "-#{rand(1..1000)}"
    end
  end
end