class CandidacyPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      # @scope.joins(race: :election).where(Election.arel_table[:election_type].eq(Election::ELECTION_TYPE_INTERNAL))
      @scope
    end
  end

  def index?
    if @record.race.election.external?
      true
    else
      @user.can_show_internal_races?
    end
  end

  def show?
  end
end
