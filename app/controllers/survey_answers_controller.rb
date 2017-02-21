class SurveyAnswersController < ApplicationController
  skip_before_action :set_current_user, :authenticate_request

  def index
    survey_answers = SurveyAnswer.all

    render json: survey_answers
  end

  def create
    attributes = survey_answer_params[:attributes] || {}
    relationships = survey_answer_params[:relationships] || {}

    survey_id = relationships[:survey][:data][:id]
    answers = attributes[:answers]
    email = attributes[:email]

    survey = Survey.find(survey_id)
    member = Member.where({ email: email, status: "active"})
      .order(databank_id: :desc)
      .first

    survey_answer = SurveyAnswer.new(
      contents: {answers: answers, email: email},
      member: member,
      survey: survey
    )

    if survey_answer.save
      render json: survey_answer, status: :created
    else
      render json: { errors: survey_answer.errors },
        status: :unprocessable_entity
    end
  end

  def update
    render json: { errors: [
      "This survey has already been completed for the email address provided"
    ] }, status: :unprocessable_entity
  end

  private

  def survey_answer_params
    params.require(:data).permit!
  end
end
