class ContactBank < ApplicationRecord
  has_many :contactors
  has_many :users, through: :contactors
  has_many :contactees
  has_many :members, through: :contactees

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :chapter

  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :members
end