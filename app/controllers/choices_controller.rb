class ChoicesController < ApplicationController
  def new
    @choice = Choice.new(question: Question.find(params[:question_id]), order_index: params[:after_order_index].to_i + 1)
    @choice.save
    redirect_to edit_question_path(@choice.question)
  end

  def move_up
    @choice = Choice.find(params[:id])

    if (order_index = @choice.order_index) > 1
      other_choice = Choice.where(question: @choice.question, order_index: order_index - 1).first
      @choice.update(order_index: order_index - 1)
      other_choice.update(order_index: order_index)
    end

    redirect_to edit_question_path(@choice.question)
  end

  def move_down
    @choice = Choice.find(params[:id])

    if (order_index = @choice.order_index) < @choice.question.choices.count
      other_choice = Choice.where(question: @choice.question, order_index: order_index + 1).first
      @choice.update(order_index: order_index + 1)
      other_choice.update(order_index: order_index)
    end

    redirect_to edit_question_path(@choice.question)
  end

  def destroy
    @choice = Choice.find(params[:id])
    question = @choice.question

    @choice.destroy

    redirect_to edit_question_path(question)
  end
end