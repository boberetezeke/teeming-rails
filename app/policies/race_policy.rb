class RacePolicy < ApplicationPolicy
  def show_candidacies?
    if @user.can_manage_internal_candidacies?
      true
    else
      @record.election.external? || Time.zone.now.to_date >= @record.candidates_announcement_date
    end
  end

  def show?
    true
  end

  def edit?
    can_write_race?
  end

  def update?
    can_write_race?
  end

  def destroy?
    can_write_race?
  end

  def can_write_race?
    (@record.election.external? && (!@record.is_official || @user.can_manage_external_candacies?)) ||
    (@record.election.internal? && @user.can_manage_internal_candidacies?)
  end
end