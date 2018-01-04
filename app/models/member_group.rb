class MemberGroup < ApplicationRecord
  has_many :member_group_memberships
  has_many :members, through: :member_group_memberships

  GROUP_TYPE_SCOPE = 'scope'
  GROUP_TYPE_COMMITTEE = 'committee'
  GROUP_TYPES = [GROUP_TYPE_SCOPE, GROUP_TYPE_COMMITTEE]

  def self.write_member_groups
    MemberGroup.where(group_type: GROUP_TYPE_SCOPE).destroy_all

    Member::SCOPE_TYPES.each do |scope_type, scope_name|
      MemberGroup.create(name: scope_name, group_type: GROUP_TYPE_SCOPE, scope_type: scope_type)
    end
  end

  def all_members(chapter)
    if group_type == GROUP_TYPE_SCOPE
      if chapter
        if chapter.is_state_wide
          scope = Member.all
        else
          scope = chapter.members
        end
      else
        scope = Member.all
      end
      apply_scope(scope, chapter)
    else
      members
    end
  end

  def apply_scope(scope, chapter)
    if Member::SCOPE_TYPES[scope_type.to_sym]
      scope.send(scope_type, chapter)
    else
      scope
    end
  end
end
