class MessagePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def index?
    true
  end

  def show?
    can_send_messages?
  end

  def new?
    can_for_scope?(@user.can_send_messages?, context_params)
  end

  def edit?
    can_send_messages?
  end

  def create?
    can_send_messages?
  end

  def update?
    can_send_messages?
  end

  def destroy?
    can_send_messages?
  end

  private

  def can_send_messages?
    can_for_scope?(@user.can_send_messages?)
  end
end
