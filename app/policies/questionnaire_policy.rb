class QuestionnairePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve

    end
  end

  def index?
    @user.can_view_questionnaires?
  end

  def show?
    @user.can_view_questionnaires?
  end

  def new?
    @user.can_write_questionnaires?
  end

  def create?
    @user.can_write_questionnaires?
  end

  def edit?
    @user.can_write_questionnaires?
  end

  def update?
    @user.can_write_questionnaires?
  end

  def destroy?
    @user.can_write_questionnaires?
  end
end