class EventPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    can_for_scope?(@user.can_write_events?, context_params)
  end

  def create?
    can_write_events?
  end

  def edit?
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
    can_for_scope?(@user.can_write_events?)
  end
end
