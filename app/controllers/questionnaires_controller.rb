class QuestionnairesController < ApplicationController
  def index
    @questionnaires = Questionnaire.all
  end

  def show
    @questionnaire = Questionnaire.find(params[:id])
    @candidacy = Candidacy.new(answers: @questionnaire.new_answers)
  end

  def new
    @questionnaire = Questionnaire.new
  end

  def create
    @questionnaire = Questionnaire.new(questionnaire_params)

    @questionnaire.save

    respond_with @questionnaire
  end

  def edit
    @questionnaire = Questionnaire.find(params[:id])
  end

  def update
    @questionnaire = Questionnaire.find(params[:id])

    @questionnaire.update(questionnaire_params)

    respond_with @questionnaire
  end

  def destroy
    @questionnaire = Questionnaire.find(params[:id])
    @questionnaire.destroy

    redirect_to questionnaires_path
  end

  private

  def questionnaire_params
    params.require(:questionnaire).permit(:name)
  end
end