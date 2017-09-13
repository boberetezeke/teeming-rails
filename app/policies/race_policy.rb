class RacePolicy < ApplicationPolicy
  def show?
    true
  end

  def show_candidacies?
    if @user.can_show_internal_candidacies?
      true
    else
      @record.election.external? || Time.zone.now.to_date >= @record.candidates_announcement_date
    end
  end

  def votes?
    @record.election.internal?
  end
end