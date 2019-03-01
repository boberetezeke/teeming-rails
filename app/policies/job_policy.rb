class JobPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if @user.admin?
        @scope.all
      else
        @scope.where("false")
      end
    end
  end

  def show?
    @user.admin?
  end

  def destroy?
    @user.admin?
  end
end

