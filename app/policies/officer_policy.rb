class OfficerPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def index?
    true
  end

  def new?
    can_write_officers?(context_params: context_params)
  end

  def create?
    can_write_officers?
  end

  def edit?
    can_write_officers?
  end

  def update?
    can_write_officers?
  end

  def destroy?
    can_write_officers?
  end

  private

  def can_write_officers?(context_params: nil)
    can_for_scope?(@user.can_write_officers?, context_params)
  end
end

