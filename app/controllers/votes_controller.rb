class VotesController < ApplicationController
  def index
    @race = Race.find(params[:race_id])
    authorize @race, :votes?

    @votes = current_user.votes.for_race(@race).includes(:candidacy)
    @vote_completed = current_user.voted_in_race?(@race)
    @overflow_districts = {}

    breadcrumbs votes_breadcrumbs("Votes for #{@race.name}")
  end

  def create
    @race = Race.find(params[:race_id])
    authorize @race, :votes?

    breadcrumbs votes_breadcrumbs("Votes for #{@race.name}")

    if params[:votes]
      @votes = params[:votes].keys.map do |candidacy_id|
        Vote.new(candidacy: Candidacy.find(candidacy_id), user: current_user, race: @race)
      end
    else
      @votes = []
    end

    valid, @overflow_districts = @race.votes_valid?(@votes)
    if valid
      @votes.each { |vote| vote.save }
      VoteCompletion.create(race: @race, user: current_user, has_voted: true)

      flash[:notice] = "Your votes have been recorded"
      redirect_to @race
    else
      render 'index'
    end
  end

  private

  def votes_breadcrumbs(title, include_link: true)
    title
  end
end