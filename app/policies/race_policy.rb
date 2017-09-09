class RacePolicy < ApplicationPolicy
  def show?
    if @record.election.external?
      true
    else
      @user.can_show_internal_races?
    end
  end
end