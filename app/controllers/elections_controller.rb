class ElectionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @internal_elections = Election.internal
    @external_elections = Election.external

    breadcrumbs elections_breadcrumbs(include_link: false)
  end

  def show
    @election = Election.find(params[:id])

    breadcrumbs elections_breadcrumbs, @election.name
  end

  private

  def elections_breadcrumbs(include_link: true)
    ["Elections", include_link ? elections_path : nil]
  end

end