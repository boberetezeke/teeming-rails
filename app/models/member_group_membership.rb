class MemberGroupMembership < ApplicationRecord
  belongs_to :member
  belongs_to :member_group
end