class QuestionnaireSectionsController < ApplicationController
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

    @questionnaire_section.destroy

    redirect_to questionnaire
  end

  private

  def renumber_questionnaire_sections(questionnaire_section_begin_deleted)
    questionnaire_sections = Question.where(questionnaire: questionnaire_section_begin_deleted.questionnaire).select{ |q| q.order_index > questionnaire_section_begin_deleted.order_index }
    questionnaire_sections.each do |questionnaire_section|
      questionnaire_section.order_index -= 1
      questionnaire_section.save
    end
  end
end