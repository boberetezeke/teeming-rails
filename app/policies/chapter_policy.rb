class ChapterPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    @user.can_write_chapters?
  end

  def edit?
    @user.can_write_chapters?
  end

  def update?
    @user.can_write_chapters?
  end

  def destroy?
    @user.can_write_chapters?
  end
end
