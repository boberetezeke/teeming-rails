class MessagePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if can_for_scope?(@user.can_send_messages?, context_params)
        @scope.all
      else
        @scope.sent
      end
    end
  end

  def index?
    true
  end

  def show?
    if @record.sent?
      true
    else
      can_send_messages?
    end
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
