class MemberPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def index?
    can_for_scope?(@user.can_view_members?, context_params)
  end

  def new?
    can_for_scope?(@user.can_write_members?, context_params)
  end

  def import?
    can_for_scope?(@user.can_write_members?, context_params)
  end

  def show?
    can_view_members? || (@record.user && @record.user.officers.present?)
  end

  def edit?
    can_write_members?
  end

  def update?
    can_write_members?
  end

  def destroy?
    can_destroy_members?
  end

  private

  def can_view_members?
    can_for_scope?(@user.can_view_members?)
  end

  def can_write_members?
    @user.member == @record || @user.can_write_members?
  end

  def can_destroy_members?
    @user.member == @record ||
      (@user.can_write_members?  && @record.user.nil?)
  end
end
