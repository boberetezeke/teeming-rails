class MemberPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def index?
    can_for_scope?(@user.can_view_members?, context_params)
  end

  def show?
    can_view_members?
  end

  def edit?
    true
  end

  def update?
    true
  end

  def assign_role?
    can_for_scope?(@user.can_assign_roles?)
  end

  def assign_officer?
    can_for_scope?(@user.can_assign_officers?)
  end

  private

  def can_view_members?
    can_for_scope?(@user.can_view_members?)
  end
end
