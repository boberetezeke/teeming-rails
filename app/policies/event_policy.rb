class EventPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if can_for_scope?(@user.can_write_events?, context_params)
        @scope.all
      else
        @scope.published
      end
    end
  end

  def index?
    true
  end

  def show?
    if can_write_events?
      true
    else
      @record.published?
    end
  end

  def new?
    can_write_events?
  end

  def create?
    can_write_events?
  end

  def edit?
    can_write_events?
  end

  def publish?
    can_write_events?
  end

  def unpublish?
    can_write_events?
  end

  def email?
    can_write_events?
  end

  def update?
    can_write_events?
  end

  def destroy?
    can_write_events?
  end

  private

  def can_write_events?
    can_for_scope?(@user.can_write_events?, context_params)
  end
end
