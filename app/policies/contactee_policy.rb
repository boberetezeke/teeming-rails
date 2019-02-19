class ContacteePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      @scope.all
    end
  end

  def new?
    @record.contact_bank.contactors.where(id: @user.id).first
  end
end
