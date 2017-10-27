class ElectionPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if @user.can_view_internal_elections?
        @scope.all
      else
        @scope.joins(member_group: :member_group_membership).where(Election.arel_table[:election_type].eq(Election::ELECTION_TYPE_EXTERNAL).or(
          Election.arel_table[:election_type].eq(Election::ELECTION_TYPE_INTERNAL).and(
            MemberGroupMembership.arel_table[:member_id].eq(@user.member.id)
          )
        ))
      end
    end
  end

  def index?
    true
    # if @record.external?
    #   true
    # else
    #   @user.can_view_internal_elections?
    # end
  end

  def show?
    @user.can_view_internal_elections?
  end

  def new?
    @user.can_view_internal_elections?
  end

  def create?
    @user.can_view_internal_elections?
  end

  def edit?
    @user.can_view_internal_elections?
  end

  def update?
    @user.can_view_internal_elections?
  end

  def destroy?
    @user.can_view_internal_elections?
  end

  def vote?
    now = Time.now.utc
    @user.can_enter_votes? ||
        (@record.internal? &&
            (@record.vote_start_time && @record.vote_end_time) &&
            (@record.vote_start_time <= now && now < @record.vote_end_time) &&
            !@user.voted_in_election?(@record))
  end

  def view_vote?
    @user.voted_in_election?(@record)
  end

  def wait?
    true
  end

  def disqualified?
    true
  end

  def missed?
    true
  end

  def tallies?
    if @user.can_show_vote_tallies?
      true
    else
      @record.show_vote_tallies
    end
  end

  def enter?
    @user.can_enter_votes?
  end

  def download_votes?
    @user.can_download_votes?
  end

  def generate_tallies?
    @user.can_generate_vote_tallies?
  end

  def delete_votes?
    @user.can_delete_votes?
  end
end
