class VotesController < ApplicationController
  def index
    @race = Race.find(params[:race_id])
    authorize @race, :votes?

    @votes = current_user.votes.for_race(@race).includes(:candidacy)
    @overflow_districts = {}
  end

  def create
    @race = Race.find(params[:race_id])
    authorize @race, :votes?

    @votes = params[:votes].keys.map do |candidacy_id|
      Vote.new(candidacy: Candidacy.find(candidacy_id), user: current_user)
    end

    valid, overflow_districts = @race.votes_valid?(@votes)
    if valid
      flash[:notice] = "Your votes have been recorded"
      redirect_to @race
    else
      @overflow_districts = overflow_districts
      render 'index'
    end
  end
end