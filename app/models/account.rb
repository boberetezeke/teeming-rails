class Account < ApplicationRecord
  has_many :user_account_memberships

  def is_owner?(user)
    membership = user_account_memberships.find_by_user_id(user.id)
    membership && membership.owner?
  end
end