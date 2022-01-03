class AccountPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def index?
    true
  end

  def join?
    true
  end

  def enter?
    true
  end

  def show?
    true
  end

  def edit?
    is_owner?
  end

  def destroy?
    is_owner?
  end

  def update?
    is_owner?
  end

  def destroy?
    is_owner?
  end

  private

  def is_owner?
    @record.is_owner?(@user)
  end
end


