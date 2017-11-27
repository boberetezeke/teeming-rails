class QuestionnairesController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_questionnaire, only: [:show, :edit, :create, :destroy]

  before_action :set_context
  before_action :set_context_params

  def index
    authorize Questionnaire, :index?

    @questionnaires = Questionnaire.all
    breadcrumbs questionnaires_breadcrumbs(include_link: false)
  end

  def show
    @candidacy = Candidacy.new(answers: @questionnaire.new_answers)
    @section = @questionnaire.questionnaire_sections.where(order_index: 1).first
    questionnaireable = @questionnaire.questionnairable
    if questionnaireable.is_a?(Race)
      race = questionnaireable
      breadcrumbs [race.complete_name, race_path(questionnaireable, @context_params)], @questionnaire.name ? @questionnaire.name : "Questionnaire"
    else
      breadcrumbs questionnaires_breadcrumbs, @questionnaire.name ? @questionnaire.name : "Questionnaire"
    end
    @edit_tools = QuestionnairePolicy.new(current_user, @questionnaire).edit?
  end

  def new
    @questionnaire = Questionnaire.new
    authorize @questionnaire
  end

  def create
    @questionnaire = Questionnaire.new(questionnaire_params)
    authorize @questionnaire

    @questionnaire.save

    respond_with @questionnaire
  end

  def edit
    breadcrumbs questionnaires_breadcrumbs, @questionnaire.name
  end

  def update
    @questionnaire.update(questionnaire_params)

    respond_with @questionnaire
  end

  def destroy
    @questionnaire.destroy

    redirect_to questionnaires_path
  end

  def self.permitted_answer_attributes
    [:text, :user_id, :candidacy_id, :question_id, :order_index, :id, :text_checkboxes, :answerable_type, :answerable_id]
  end

  private

  def set_questionnaire
    @questionnaire = Questionnaire.find(params[:id])
    authorize @questionnaire
  end

  def set_context
    @chapter = Chapter.find(params[:chapter_id]) if params[:chapter_id]
  end

  def set_context_params
    @context_params = @chapter ? { chapter_id: @chapter.id } : {}
  end

  def questionnaire_params
    params.require(:questionnaire).permit(:name)
  end

  def questionnaires_breadcrumbs(include_link: true)
    ["Questionnaires", include_link ? questionnaires_path : nil]
  end
end