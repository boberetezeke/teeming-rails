class RoleAssignment < ApplicationRecord
  belongs_to :account

  belongs_to :user
  belongs_to :officer
  belongs_to :role
end