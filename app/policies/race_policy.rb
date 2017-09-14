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

  def vote?
    now = Time.now.utc
    @record.election.internal? &&
        (@record.vote_start_time && @record.vote_end_time) &&
        (@record.vote_start_time <= now && now < @record.vote_end_time) # &&
        !@user.voted_in_race?(@record)
  end

  def view_vote?
    @user.voted_in_race?(@record)
  end

  def tallies?
    @user.can_show_vote_tallies?
  end
end