class UserAccountMembership < ApplicationRecord
  belongs_to :user
  belongs_to :account

  ROLE_OWNER = 'owner'

  def owner?
    role == ROLE_OWNER
  end
end