class Account < ApplicationRecord
  has_many :user_account_memberships, dependent: :destroy
  has_many :chapters, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :privileges, dependent: :destroy
  has_many :role_assignments, dependent: :destroy

  def is_owner?(user)
    membership = user_account_memberships.find_by_user_id(user.id)
    membership && membership.owner?
  end
end