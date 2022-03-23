class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.joins(:user_account_memberships).where(user_account_memberships: { account: @user.selected_account})
    end
  end
end

