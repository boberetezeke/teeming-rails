class MeetingMinutePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if can_for_scope?(@user.can_write_meeting_minutes?, context_params)
        @scope.all
      else
        @scope.published
      end
    end
  end

  def show?
    true
  end

  def new?
    can_for_scope?(@user.can_write_meeting_minutes?, context_params)
  end

  def create?
    can_write_meeting_minutes?
  end

  def edit?
    can_write_meeting_minutes?
  end

  def update?
    can_write_meeting_minutes?
  end

  def destroy?
    can_write_meeting_minutes?
  end

  private

  def can_write_meeting_minutes?
    can_for_scope?(@user.can_write_meeting_minutes?)
  end
end

