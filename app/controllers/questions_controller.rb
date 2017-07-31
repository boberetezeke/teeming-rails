class QuestionsController < ApplicationController
  def move_up
    @question = Question.find(params[:id])

    if (order_index = @question.order_index) > 1
      other_question = Question.where(questionnaire_section: @question.questionnaire_section, order_index: order_index - 1).first
      @question.update(order_index: order_index - 1)
      other_question.update(order_index: order_index)
    end

    redirect_to @question.questionnaire_section.questionnaire
  end

  def move_down
    @question = Question.find(params[:id])

    if (order_index = @question.order_index) < @question.questionnaire_section.questions.count
      other_question = Question.where(questionnaire_section: @question.questionnaire_section, order_index: order_index + 1).first
      @question.update(order_index: order_index + 1)
      other_question.update(order_index: order_index)
    end

    redirect_to @question.questionnaire_section.questionnaire
  end

  def destroy
    @question = Question.find(params[:id])
    questionnaire = @question.questionnaire_section.questionnaire

    renumber_questions(@question)

    @question.destroy

    redirect_to questionnaire
  end

  private

  def swap_questions
  end

  def renumber_questions(question_begin_deleted)
    questions = Question.where(questionnaire_section: question_begin_deleted.questionnaire_section).select{ |q| q.order_index > question_begin_deleted.order_index }
    questions.each do |question|
      question.order_index -= 1
      question.save
    end
  end
end