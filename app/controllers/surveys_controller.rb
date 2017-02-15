class SurveysController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]

  def index
    surveys = Survey.all

    render json: surveys
  end

  def show
    survey = Survey.find(params[:id])

    render json: survey
  end
end
