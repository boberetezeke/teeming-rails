class Question < ApplicationRecord
  belongs_to :questionnaire_section
  has_many   :choices, dependent: :destroy
  has_many   :answers, dependent: :destroy
  has_many   :choice_tallies, dependent: :destroy

  accepts_nested_attributes_for :choices

  validates :text, presence: true

  QUESTION_TYPE_SHORT_TEXT =      'short_text'
  QUESTION_TYPE_LONG_TEXT =       'long_text'
  QUESTION_TYPE_MULTIPLE_CHOICE = 'multiple_choice'
  QUESTION_TYPE_CHECKBOXES =      'checkboxes'
  QUESTION_TYPE_RANKED_CHOICE =   'ranked_choice'

  QUESTION_TYPES = {
    "Short text" => QUESTION_TYPE_SHORT_TEXT,
    "Long text" => QUESTION_TYPE_LONG_TEXT,
    "Single choice" => QUESTION_TYPE_MULTIPLE_CHOICE,
    "Multiple choices" => QUESTION_TYPE_CHECKBOXES,
    "Ranked choices" => QUESTION_TYPE_RANKED_CHOICE
  }

  default_scope ->{ order('order_index asc') }

  def new_answer(candidacy: nil, index: nil, user: nil)
    Answer.new(candidacy: candidacy, question: self, order_index: index, user: user)
  end

  def ranked_choice?
    question_type == QUESTION_TYPE_RANKED_CHOICE
  end

  def has_choices?
    question_type == QUESTION_TYPE_CHECKBOXES ||
    question_type == QUESTION_TYPE_MULTIPLE_CHOICE ||
    question_type == QUESTION_TYPE_RANKED_CHOICE
  end

  def answer_totals
    totals = {}
    answers.each do |answer|
      totals[answer.text] ||= 0
      totals[answer.text] += 1
    end
    totals
  end

  def num_rounds
    choice_tallies.order('round desc').first.round
  end

  def winner
    winning_index = choice_tallies.where(question: self, round: num_rounds).order('count desc').first.value.to_i

    choices.order("order_index asc")[winning_index-1]
  end

  def copy
    new_question = self.dup
    new_question.save
    self.choices.each do |choice|
      new_question.choices << choice.copy
    end

    new_question
  end
end