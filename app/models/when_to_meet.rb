class WhenToMeet < ApplicationRecord
  class User
    include ActiveModel::Validations

    attr_accessor :name, :email, :is_creator
    attr_reader :id

    validates :name, presence: true
    validates :email, presence: true, format: /\A[^@]+@[^@]+\z/

    def initialize(name:, email:, is_creator:, id: nil)
      @name = name
      @email = email
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
        id = m[1]
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

  attr_accessor :user_name, :user_email

  validates :name, presence: true

  serialize :users
  serialize :time_slots

  def find_user_by_id(id)
    return nil if id.nil?
    users.to_a.select{|user| user.id == id}.first
  end

  def find_user_by_email(email)
    users.to_a.select{|user| user.email == email}.first
  end

  def new_user(user_name, user_email, is_creator)
    User.new(user_name, user_email, id_for_email(user_email), is_creator)
  end

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
end