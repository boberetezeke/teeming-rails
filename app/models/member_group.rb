class MemberGroup < ApplicationRecord
  belongs_to :account

  has_many :member_group_memberships
  has_many :members, through: :member_group_memberships

  has_many :elections, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :officers, dependent: :destroy
  has_many :meeting_minutes, dependent: :destroy

  GROUP_TYPE_SCOPE = 'scope'
  GROUP_TYPE_COMMITTEE = 'committee'
  GROUP_TYPES = [GROUP_TYPE_SCOPE, GROUP_TYPE_COMMITTEE]

  default_scope ->{ order('name asc') }

  def self.write_member_groups
    Member::SCOPE_TYPES.each do |scope_type, scope_name|
      unless MemberGroup.find_by_name(scope_name)
        MemberGroup.create(name: scope_name, group_type: GROUP_TYPE_SCOPE, scope_type: scope_type)
      end
    end
  end

  def self.state_wide_groups
    all.reject{|mg| mg.scope_type == 'potential_chapter_members'}
  end

  def self.chapter_groups
    all.reject{|mg| mg.scope_type == 'all_members'}
  end

  def all_members(chapter)
    if group_type == GROUP_TYPE_SCOPE
      if chapter
        if (chapter.is_state_wide &&
              (scope_type == 'all_members' ||  scope_type == 'all_users')) ||
            scope_type == 'potential_chapter_members'
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
