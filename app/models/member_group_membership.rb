class MemberGroupMembership < ApplicationRecord
  belongs_to :account

  belongs_to :member
  belongs_to :member_group
end