class ChoicesController < ApplicationController
  before_filter :authenticate_user!

  # this should be def new_blank
  def show
    after_order_index = params[:after_order_index].to_i
    @choice = Choice.new(question: Question.find(params[:question_id]), order_index: after_order_index + 1)

    renumber_choices(@choice, @choice.order_index, 1)

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

  def delete
    @choice = Choice.find(params[:id])
    question = @choice.question

    renumber_choices(@choice, @choice.order_index, -1)

    @choice.destroy

    redirect_to edit_question_path(question)
  end

  private

  def renumber_choices(choice, order_index, adjustment)
    Choice.where(
      Choice.arel_table[:question_id].eq(choice.question.id).and(
      Choice.arel_table[:order_index].gteq(order_index)
    )).each do |c|
      c.order_index += adjustment
      c.save
    end
  end
end