class ContactBankPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def show?
    Contactor.exists?(contact_bank_id: @record.id, user_id: @user.id) ||
    @record.owner_id == @user.id
  end

  def new?
    can_write_contact_banks?
  end

  def create?
    can_write_contact_banks?
  end

  def edit?
    can_write_contact_banks?
  end

  def update?
    can_write_contact_banks?
  end

  def destroy?
    can_write_contact_banks?
  end

  private

  def can_write_contact_banks?
    can_for_scope?(@user.can_write_contact_banks?, context_params)
  end
end

