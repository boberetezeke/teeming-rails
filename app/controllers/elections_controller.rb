class ElectionsController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_election, only: [:show, :edit, :update, :destroy]

  def index
    authorize Election

    @internal_elections = Election.internal
    @external_elections = Election.external

    breadcrumbs elections_breadcrumbs(include_link: false)
  end

  def show
    breadcrumbs elections_breadcrumbs, @election.name
  end

  def new
    @election = Election.new(election_type: Election::ELECTION_TYPE_INTERNAL)
    breadcrumbs elections_breadcrumbs, 'New election'
  end

  def create
    @election = Election.new(election_params)
    @election.save

    respond_with(@election)
  end

  def edit
    @election.set_accessors
    breadcrumbs elections_breadcrumbs, "Edit #{@election.name}"
  end

  def update
    @election.update(election_params)

    respond_with(@election)
  end

  def destroy
    @election.destroy
    redirect_to elections_path
  end

  private

  def set_election
    @election = Election.find(params[:id])
    authorize @election
  end

  def election_params
    params.require(:election).permit(:name, :election_type, :vote_date_str, :vote_start_time_str, :vote_end_time_str)
  end

  def elections_breadcrumbs(include_link: true)
    ["Elections", include_link ? elections_path : nil]
  end

end