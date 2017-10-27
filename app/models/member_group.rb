class MemberGroup < ApplicationRecord
  has_many :member_group_memberships
  has_many :members, through :member_group_memberships
end
