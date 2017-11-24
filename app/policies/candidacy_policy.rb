class CandidacyPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if @user.can_manage_internal_candidacies?
        @scope.all
      else
        @scope.joins(race: :election).where(
          Election.arel_table[:election_type].eq(Election::ELECTION_TYPE_EXTERNAL).or(
            Race.arel_table[:candidates_announcement_date].lteq(Time.zone.now.to_date)
          )
        )
      end
    end
  end

  def index?
    if @record.race.election.external?
      true
    else
      @user.can_manage_internal_candidacies?
    end
  end

  def show?
    true
    # @record.user == @user || @user.can_view_internal_candidacies?
  end
end
