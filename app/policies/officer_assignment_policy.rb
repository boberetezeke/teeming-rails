class OfficerAssignmentPolicy < ApplicationPolicy
  def show?
    true
  end

  def new?
    can_for_scope?(@user.can_write_officers?, context_params)
  end

  def create?
    can_for_scope?(@user.can_write_officers?, context_params)
  end

  def edit?
    can_write_officers?(context_params: context_params)
  end

  def update?
    can_write_officers?(context_params: context_params)
  end

  def destroy?
    can_write_officers?(context_params: context_params)
  end

  private

  def can_write_officers?(context_params: nil)
    can_for_scope?(@user.can_write_officers?, context_params)
  end
end
