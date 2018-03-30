class QuestionnaireSectionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @questionnaire_section = QuestionnaireSection.new(questionnaire: @questionnaire, order_index: params[:after_order_index].to_i + 1)
  end

  def create
    @questionnaire_section = QuestionnaireSection.new(questionnaire_section_params)
    @questionnaire = @questionnaire_section.questionnaire

    if @questionnaire_section.valid?
      renumber_question_sections(@questionnaire, @questionnaire_section.order_index, 1)
    end

    if @questionnaire_section.save
      redirect_to @questionnaire
    else
      render 'new'
    end
  end

  def edit
    @questionnaire_section = QuestionnaireSection.find(params[:id])
  end

  def update
    @questionnaire_section = QuestionnaireSection.find(params[:id])
    if @questionnaire_section.update(questionnaire_section_params)
      redirect_to @questionnaire_section.questionnaire
    else
      render 'edit'
    end
  end

  def move_up
    @questionnaire_section = QuestionnaireSection.find(params[:id])

    if (order_index = @questionnaire_section.order_index) > 1
      other_questionnaire_section = QuestionnaireSection.where(questionnaire: @questionnaire_section.questionnaire, order_index: order_index - 1).first
      @questionnaire_section.update(order_index: order_index - 1)
      other_questionnaire_section.update(order_index: order_index)
    end

    redirect_to @questionnaire_section.questionnaire
  end

  def move_down
    @questionnaire_section = QuestionnaireSection.find(params[:id])

    if (order_index = @questionnaire_section.order_index) < @questionnaire_section.questions.count
      other_questionnaire_section = QuestionnaireSection.where(questionnaire: @questionnaire_section.questionnaire, order_index: order_index + 1).first
      @questionnaire_section.update(order_index: order_index + 1)
      other_questionnaire_section.update(order_index: order_index)
    end

    redirect_to @questionnaire_section.questionnaire
  end

  def destroy
    @questionnaire_section = QuestionnaireSection.find(params[:id])
    questionnaire = @questionnaire_section.questionnaire
    order_index = @questionnaire_section.order_index

    @questionnaire_section.destroy

    renumber_question_sections(questionnaire, order_index+1, -1)

    redirect_to questionnaire
  end

  private

  def renumber_question_sections(questionnaire, order_index, adjustment)
    QuestionnaireSection.where(
        QuestionnaireSection.arel_table[:questionnaire_id].eq(questionnaire.id).and(
        QuestionnaireSection.arel_table[:order_index].gteq(order_index)
    )).each do |qe|
      qe.order_index += adjustment
      qe.save
    end
  end

  def questionnaire_section_params
    params.require(:questionnaire_section).permit(:title, :questionnaire_id, :order_index)
  end
end