class MessagePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def index?
    @user.can_send_messages?
  end

  def show?
    @user.can_send_messages?
  end

  def new?
    @user.can_send_messages?
  end

  def edit?
    @user.can_send_messages?
  end

  def create?
    @user.can_send_messages?
  end

  def update?
    @user.can_send_messages?
  end
end
