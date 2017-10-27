class QuestionnairesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @questionnaires = Questionnaire.all
    breadcrumbs questionnaires_breadcrumbs(include_link: false)
  end

  def show
    @questionnaire = Questionnaire.find(params[:id])
    @candidacy = Candidacy.new(answers: @questionnaire.new_answers)
    @section = @questionnaire.questionnaire_sections.where(order_index: 1).first
    breadcrumbs questionnaires_breadcrumbs, @questionnaire.name
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
    breadcrumbs questionnaires_breadcrumbs, @questionnaire.name
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

  def questionnaires_breadcrumbs(include_link: true)
    ["Questionnaires", include_link ? questionnaires_path : nil]
  end
end