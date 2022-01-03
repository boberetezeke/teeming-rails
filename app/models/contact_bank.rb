class ContactBank < ApplicationRecord
  belongs_to :account

  has_many :contactors
  has_many :users, through: :contactors
  has_many :contactees
  has_many :members, through: :contactees

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :chapter

  validates :name, presence: true

  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :members

  def contactees_attempted
    contactees.attempted
  end

  def contactees_contacted
    contactees.contacted
  end

  def contactor_for_user(user)
    contactors.where(user_id: user.id).first
  end
end