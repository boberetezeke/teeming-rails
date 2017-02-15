class CandidatesController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]

  def index
    if params[:slug]
      candidates = Candidate.find_by_name(params[:slug].titleize)
    else
      candidates = Candidate.order(:office)
    end

    render json: candidates
  end

  def show
    candidate = Candidate.find(params[:id])

    render json: candidate
  end
end
