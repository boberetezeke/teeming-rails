class CandidatesController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]

  def index
    if params[:code]
      candidates = Candidate.find_by_code(params[:code])
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
