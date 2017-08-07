class QuestionsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @question = Question.new(questionnaire_section_id: params[:questionnaire_section_id], question_type: Question::QUESTION_TYPE_SHORT_TEXT, order_index: params[:after_order_index].to_i + 1)

    questions_breadcrumbs(@question)
  end

  def create
    @question = Question.new(question_params)
    @questionnaire = @question.questionnaire_section.questionnaire

    if @question.valid?
      renumber_questions(@question, @question.order_index, 1)
    end

    if @question.save
      redirect_to @questionnaire
    else
      render 'new'
    end
  end

  def edit
    @question = Question.find(params[:id])
    questions_breadcrumbs(@question)
  end

  def update
    @question = Question.find(params[:id])

    if @question.update(question_params)
      if params[:redirect_location].blank?
        redirect_to @question.questionnaire_section.questionnaire
      else
        redirect_to params[:redirect_location]
      end
    else
      render 'edit'
    end
  end

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

    renumber_questions(@question, @question.order_index, -1)

    @question.destroy

    redirect_to questionnaire
  end

  private

  def question_params
    params.require(:question).permit(:questionnaire_section_id, :text, :question_type, :order_index, choices_attributes: [:id, :order_index, :title])
  end

  def questions_breadcrumbs(question)
    questionnaire = question.questionnaire_section.questionnaire
    breadcrumbs [questionnaire.name, questionnaire_path(questionnaire)], ["Question", nil]
  end

  def renumber_questions(question, order_index, adjustment)
    Question.where(
        Question.arel_table[:questionnaire_section_id].eq(question.questionnaire_section.id).and(
        Question.arel_table[:order_index].gteq(order_index)
    )).each do |q|
      q.order_index += adjustment
      q.save
    end
  end
end