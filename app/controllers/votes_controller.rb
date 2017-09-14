class VotesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @race = Race.find(params[:race_id])
    authorize @race, :vote?

    @votes = current_user.votes.for_race(@race).includes(:candidacy)
    @overflow_districts = {}

    breadcrumbs votes_breadcrumbs, "Vote"
  end

  def view
    @race = Race.find(params[:race_id])
    authorize @race, :view_vote?

    @votes = current_user.votes.for_race(@race).includes(:candidacy)

    breadcrumbs votes_breadcrumbs, "View Votes"
  end

  def create
    @race = Race.find(params[:race_id])
    authorize @race, :vote?

    breadcrumbs votes_breadcrumbs, "Vote"

    user_valid = true
    vote_completion_type = VoteCompletion::VOTE_COMPLETION_TYPE_ONLINE
    if params[:voter_email]
      vote_completion_type = VoteCompletion::VOTE_COMPLETION_TYPE_PAPER
      @voter_email = params[:voter_email]
      user = User.find_by_email(params[:voter_email])

      if user
        if vote_completion = user.voted_in_race?(@race)
          user_valid = false
          @voter_email_error = "voter has already voted (#{vote_completion.vote_type})"
        end
      else
        @voter_email_error = "email not found"
        user_valid = false
      end
    else
      user = current_user
      if user.voted_in_race?(@race)
        user_valid = false
        @voter_error = "you have already voted"
      end
    end

    if params[:votes]
      @votes = params[:votes].keys.map do |candidacy_id|
        Vote.new(candidacy: Candidacy.find(candidacy_id), user: user, race: @race)
      end
    else
      @votes = []
    end

    votes_valid, @overflow_districts = @race.votes_valid?(@votes)

    if votes_valid && user_valid
      @votes.each { |vote| vote.save }
      VoteCompletion.create(race: @race, user: user, has_voted: true, vote_type: vote_completion_type)

      if params[:voter_email]
        flash[:notice] = "The vote has been recorded"
        redirect_to enter_race_votes_path(@race)
      else
        flash[:notice] = "Your votes have been recorded"
        redirect_to @race
      end

    else
      if params[:voter_email]
        render 'enter'
      else
        render 'index'
      end
    end
  end

  def tallies
    @race = Race.find(params[:race_id])
    authorize @race, :tallies?

    @tallies = @race.tally_votes

    breadcrumbs votes_breadcrumbs, "Vote"
  end

  def enter
    @race = Race.find(params[:race_id])
    authorize @race, :enter?

    @votes = []
    @overflow_districts = {}

    breadcrumbs votes_breadcrumbs, "Vote"
  end

  def delete_votes
    @race = Race.find(params[:race_id])
    authorize @race, :delete_votes?

    @race.votes.destroy_all
    @race.vote_completions.destroy_all

    redirect_to @race
  end

  private

  def votes_breadcrumbs(include_link: true)
    [@race.name, race_path(@race)]
  end
end