class ContacteePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def show?
    is_a_contactor?
  end

  def edit?
    is_a_contactor?
  end

  def update?
    is_a_contactor?
  end

  private

  def is_a_contactor?
    @record.contact_bank.contactors.where(user_id: @user.id).first
  end
end
