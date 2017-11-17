class EventPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def show?
    true
  end

  def new?
    @user.can_write_events?
  end

  def create?
    @user.can_write_events?
  end

  def edit?
    @user.can_write_events?
  end

  def update?
    @user.can_write_events?
  end

  def destroy?
    @user.can_write_events?
  end
end
