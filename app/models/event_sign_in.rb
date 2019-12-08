class EventRsvp < ApplicationRecord
  belongs_to :account

  belongs_to :event

  belongs_to :member
  accepts_nested_attributes_for :member

  attr_accessor :email
end

