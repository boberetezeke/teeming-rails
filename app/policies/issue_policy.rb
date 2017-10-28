class IssuePolicy < ApplicationPolicy
  def show?
    @user.can_view_internal_elections? || @user.can_vote_in_election?(@record.election)
  end
end

