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
    @user.can_enter_votes? ||
      (@record.election.internal? &&
          (@record.vote_start_time && @record.vote_end_time) &&
          (@record.vote_start_time <= now && now < @record.vote_end_time) &&
          !@user.voted_in_race?(@record))
  end

  def view_vote?
    @user.voted_in_race?(@record)
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