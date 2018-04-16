class MessageControlPolicy < ApplicationPolicy
  def create?
    has_no_user_or_is_user_owner
  end

  def show?
    has_no_user_or_is_user_owner
  end

  def edit?
    has_no_user_or_is_user_owner
  end

  def update?
    has_no_user_or_is_user_owner
  end

  private

  def has_no_user_or_is_user_owner
    @record.member.user ? @record.member.user == @user : true
  end
end

