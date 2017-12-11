class ElectionPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if @user.can_manage_internal_elections?
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

  class AssociatedObjects < ApplicationPolicy::AssociatedObjects
    def new?
      { chapters: chapters_for_scope(@user.scope_for_manage_internal_elections) }
    end

    def edit?
      { chapters: chapters_for_scope(@user.scope_for_manage_internal_elections) }
    end
  end

  def index?
    true
    # if @record.external?
    #   true
    # else
    #   @user.can_manage_internal_elections?
    # end
  end

  def show?
    can_manage_internal_elections? || @user.can_vote_in_election?(@record)
  end

  def new?
    can_for_scope?(@user.can_manage_internal_elections?, context_params)
  end

  def create?
    can_manage_internal_elections?
  end

  def edit?
    can_manage_internal_elections?
  end

  def freeze?
    can_manage_internal_elections?
  end

  def unfreeze?
    can_manage_internal_elections?
  end

  def update?
    can_manage_internal_elections?
  end

  def destroy?
    can_manage_internal_elections?
  end

  def vote?
    now = Time.now.utc
    #@user.can_enter_votes? ||
        (@record.internal? &&
            (@record.vote_start_time && @record.vote_end_time) &&
            (@record.vote_start_time <= now && now < @record.vote_end_time) &&
            @user.can_vote_in_election?(@record) &&
            !@user.voted_in_election?(@record))
  end

  def view_vote?
    @user.voted_in_election?(@record)
  end

  def wait?
    @user.can_enter_votes? || @user.can_vote_in_election?(@record)
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

  private

  def can_manage_internal_elections?
    can_for_scope?(@user.can_manage_internal_elections?)
  end
end
