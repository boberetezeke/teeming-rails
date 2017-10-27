class RacePolicy < ApplicationPolicy
  def show?
    true
  end

  def show_candidacies?
    if @user.can_view_internal_candidacies?
      true
    else
      @record.election.external? || Time.zone.now.to_date >= @record.candidates_announcement_date
    end
  end

end