class MemberPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      # if @user.can_show_internal_candidacies?
      #   @scope.all
      # else
      #   @scope.joins(race: :election).where(
      #       Election.arel_table[:election_type].eq(Election::ELECTION_TYPE_EXTERNAL).or(
      #           Race.arel_table[:candidates_announcement_date].lteq(Time.zone.now.to_date)
      #       )
      #   )
      # end
    end
  end

  def index?
    @user.can_view_members?
  end

  def show?
    @user.can_view_members?
  end
end
