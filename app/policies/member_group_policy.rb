class MemberGroupPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def index?
    @user.can_view_members?
  end

  def show?
    @user.can_view_members?
  end
end
