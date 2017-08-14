class RacesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @election = Election.find(params[:election_id])
    @races = @election.races
    breadcrumbs ["Elections", elections_path], races_breadcrumbs(@election, include_link: false)
  end

  def show
    @race = Race.find(params[:id])
    breadcrumbs races_breadcrumbs(@race.election), @race.complete_name
  end

  def new
    @election = Election.find(params[:election_id])
    @race = Race.new(election: @election)
  end

  def create
    @race = Race.new(race_params)

    @race.created_by_user = current_user
    @race.save

    respond_with @race, location: race_path(@race)
  end

  def edit
    @race = Race.find(params[:id])
    breadcrumbs races_breadcrumbs(@race.election), @race.complete_name
  end

  def update
    @race = Race.find(params[:id])

    @race.updated_by_user = current_user
    @race.update(race_params)

    respond_with @race, location: race_path(@race)
  end

  def destroy
    @race = Race.find(params[:id])
    @election = @race.election
    @race.destroy

    redirect_to election_races_path(@election)
  end

  private

  def race_params
    params.require(:race).permit(:name, :election_id, :level_of_government, :locale)
  end

  def races_breadcrumbs(election, include_link: true)
    ["#{election.name} Races", include_link ? election_races_path(election) : nil]
  end
end